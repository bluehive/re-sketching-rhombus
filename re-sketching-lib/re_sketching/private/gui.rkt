#lang racket/base
(require racket/gui/base
         racket/class
         racket/draw
         "state.rkt")

(provide initialize-gui start-gui
         size pixel-density set-frame-rate!
         loop no-loop no-gui
         cursor no-cursor focused? fullscreen set-title
         actual-frame-rate)

(define top-frame #f)
(define top-canvas #f)
(define top-bitmap #f)
(define top-bitmap-dc #f)
(define top-timer #f)
(define the-keyboard (make-hasheq))

(define (key-down! k) (hash-set! the-keyboard k #t))
(define (key-up! k)   (hash-set! the-keyboard k #f))
(define (key-down? k) (hash-ref the-keyboard k #f))

(define sketch-frame%
  (class frame%
    (define/augment (on-close)
      (when top-timer (send top-timer stop)))
    (super-new)))

(define sketch-canvas%
  (class canvas%
    (super-new)
    (define mouse-inside? #f)

    (define/override (on-event e)
      (when (is-a? e mouse-event%)
        (when (send e entering?) (set! mouse-inside? #t))
        (when (send e leaving?)  (set! mouse-inside? #f))
        (unless (and (eq? (system-type) 'windows) (not mouse-inside?))
          (current-mouse-x (send e get-x))
          (current-mouse-y (send e get-y)))
        (define type (send e get-event-type))
        (case type
          [(left-up)     (current-mouse-left-pressed #f) (current-mouse-button 'left)]
          [(middle-up)   (current-mouse-middle-pressed #f) (current-mouse-button 'middle)]
          [(right-up)    (current-mouse-right-pressed #f) (current-mouse-button 'right)]
          [(left-down)   (current-mouse-left-pressed #t) (current-mouse-button 'left)]
          [(middle-down) (current-mouse-middle-pressed #t) (current-mouse-button 'middle)]
          [(right-down)  (current-mouse-right-pressed #t) (current-mouse-button 'right)]
          [else (void)])
        (define ups '(left-up middle-up right-up))
        (define downs '(left-down middle-down right-down))
        (define moves '(enter leave motion))
        (send this suspend-flush)
        (cond
          [(member type ups)
           (current-mouse-released #t)
           (current-mouse-pressed #f)
           (current-mouse-moved #f)
           (current-mouse-dragged #f)
           (define h (current-on-mouse-released))
           (when h (h))]
          [(member type downs)
           (current-mouse-pressed #t)
           (current-mouse-released #f)
           (current-mouse-moved #f)
           (current-mouse-dragged #f)
           (define h (current-on-mouse-pressed))
           (when h (h))]
          [(and (member type moves)
                (not (current-mouse-left-pressed))
                (not (current-mouse-middle-pressed))
                (not (current-mouse-right-pressed)))
           (current-mouse-moved #t)
           (current-mouse-dragged #f)
           (define h (current-on-mouse-moved))
           (when h (h))]
          [(and (member type moves)
                (or (current-mouse-left-pressed)
                    (current-mouse-middle-pressed)
                    (current-mouse-right-pressed)))
           (current-mouse-moved #f)
           (current-mouse-dragged #t)
           (define h (current-on-mouse-dragged))
           (when h (h))])
        (send this resume-flush)))

    (define/override (on-char e)
      (define key (send e get-key-code))
      (define release (send e get-key-release-code))
      (send this suspend-flush)
      (cond
        [(eq? release 'press)
         (unless (key-down? key)
           (key-down! key)
           (current-key-pressed #t)
           (current-key-released #f)
           (current-key key)
           (define h (current-on-key-pressed))
           (when h (h)))]
        [else
         (when (key-down? release)
           (key-up! release)
           (current-key-pressed #f)
           (current-key-released #t)
           (current-key release)
           (define h (current-on-key-released))
           (when h (h)))])
      (send this resume-flush))

    (define/override (on-paint)
      (define screen-dc (send this get-dc))
      (when top-bitmap-dc
        (handle-on-paint top-bitmap-dc)
        (send this suspend-flush)
        (send screen-dc set-transformation
              (vector (vector 1 0 0 1 0 0) 0 0 1 1 0))
        (send screen-dc draw-bitmap top-bitmap 0 0)
        (send this resume-flush)))))

(define (handle-on-paint dc)
  (parameterize ([current-dc dc])
    (define draw (current-draw))
    (when draw
      (define prev milliseconds-at-start-of-frame)
      (define now (current-milliseconds))
      (reset-milliseconds-at-start-of-frame! now)
      (reset-delta-time!
       (if (zero? prev) 1 (- now prev)))
      (define old-mx (current-mouse-x))
      (define old-my (current-mouse-y))
      (define old-t (send dc get-transformation))
      (send dc set-transformation
            (vector (vector 1 0 0 1 0 0) 0 0 1 1 0))
      (draw)
      (send dc set-transformation old-t)
      (current-pmouse-x old-mx)
      (current-pmouse-y old-my))
    (current-frame-count (add1 (current-frame-count)))))

(define (initialize-gui)
  (reset-milliseconds-at-start-of-program! (current-milliseconds))
  (define frame
    (new sketch-frame%
         [label "re-sketching"]
         [style '(fullscreen-button)]))
  (set! top-frame frame)
  (define canvas
    (new sketch-canvas%
         [parent frame]
         [min-width 100]
         [min-height 100]))
  (set! top-canvas canvas)
  (set! top-bitmap (send canvas make-bitmap 100 100))
  (set! top-bitmap-dc (new bitmap-dc% [bitmap top-bitmap]))
  (define b (new brush% [color "white"]))
  (send top-bitmap-dc set-smoothing 'aligned)
  (send top-bitmap-dc set-brush b)
  (send top-bitmap-dc set-pen (new pen% [color "black"] [width 1]))
  (current-dc top-bitmap-dc)
  (void))

(define (fps->interval fps)
  (inexact->exact (max 1 (floor (/ 1000.0 (max 1 fps))))))

(define (ensure-bitmap w h)
  (unless (and top-bitmap
               (= (send top-bitmap get-width) w)
               (= (send top-bitmap get-height) h))
    (define old-dc top-bitmap-dc)
    (set! top-bitmap (send top-canvas make-bitmap w h))
    (set! top-bitmap-dc (new bitmap-dc% [bitmap top-bitmap]))
    (send top-bitmap-dc set-smoothing 'aligned)
    (when old-dc
      (send top-bitmap-dc set-pen (send old-dc get-pen))
      (send top-bitmap-dc set-brush (send old-dc get-brush))
      (send top-bitmap-dc set-font (send old-dc get-font))
      (send top-bitmap-dc set-background (send old-dc get-background))
      (send top-bitmap-dc clear))
    (current-dc top-bitmap-dc)))

(define (start-gui)
  (define w (max 100 (current-width)))
  (define h (max 100 (current-height)))
  (send top-canvas min-width w)
  (send top-canvas min-height h)
  (ensure-bitmap w h)
  (send top-canvas set-canvas-background (send (current-dc) get-background))
  (define timer
    (new timer%
         [notify-callback handle-on-timer]
         [interval (fps->interval (current-frame-rate))]))
  (set! top-timer timer)
  (unless (current-no-gui)
    (send top-frame show #t)))

(define timer-stats (vector 1000. 1000. 1000. 1000. 1000.))
(define timer-stats-index 0)
(define timer-prev (current-inexact-milliseconds))

(define (timer-stat!)
  (define now (current-inexact-milliseconds))
  (define t (- now timer-prev))
  (set! timer-prev now)
  (vector-set! timer-stats timer-stats-index t)
  (set! timer-stats-index (modulo (add1 timer-stats-index) 5)))

(define (timer-mean)
  (* 0.2 (for/sum ([t (in-vector timer-stats)]) t)))

(define (handle-on-timer)
  (timer-stat!)
  (current-actual-frame-rate (/ (round (* 10 (/ 1000.0 (max 1.0 (timer-mean))))) 10.0))
  (when (current-loop-running?)
    (send top-canvas on-paint)
    (define want (fps->interval (current-frame-rate)))
    (unless (equal? (send top-timer interval) want)
      (send top-timer start want))))

(define (size w h)
  (current-width (inexact->exact (round w)))
  (current-height (inexact->exact (round h)))
  (set-pixel-width!  (* (current-density) (current-width)))
  (set-pixel-height! (* (current-density) (current-height)))
  (when top-canvas
    (send top-canvas min-width (max 100 (current-width)))
    (send top-canvas min-height (max 100 (current-height)))
    (ensure-bitmap (max 100 (current-width)) (max 100 (current-height))))
  (void))

(define (pixel-density d)
  (current-density d)
  (set-pixel-width!  (* d (current-width)))
  (set-pixel-height! (* d (current-height)))
  (void))

(define (set-frame-rate! fps)
  (current-frame-rate fps)
  (void))

(define (actual-frame-rate) (current-actual-frame-rate))

(define (loop) (current-loop-running? #t) (void))
(define (no-loop) (current-loop-running? #f) (void))
(define (no-gui) (current-no-gui #t) (void))

(define (focused?)
  (and top-frame (send top-frame get-focus-window) #t))

(define (set-title s)
  (when (and top-frame (label-string? s))
    (send top-frame set-label s)))

(define (fullscreen)
  (when top-frame
    (send top-frame fullscreen #t)
    (send top-frame focus)
    (define-values (w h) (get-display-size))
    (current-width w)
    (current-height h)))

(define cursor-symbols
  '(arrow bullseye cross hand ibeam watch blank
          size-n/s size-e/w size-ne/sw size-nw/se))

(define (cursor sym)
  (when (and top-frame (member sym cursor-symbols))
    (send top-frame set-cursor (make-object cursor% sym))))

(define (no-cursor)
  (when top-frame
    (send top-frame set-cursor #f)))
