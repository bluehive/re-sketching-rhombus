#lang racket/base
;;; Dynamic sketch state (Processing "system variables" + style).

(provide
 current-dc with-dc
 current-width current-height
 current-density
 pixel-width pixel-height set-pixel-width! set-pixel-height!
 current-frame-count current-frame-rate current-actual-frame-rate
 current-loop-running?
 current-mouse-x current-mouse-y
 current-pmouse-x current-pmouse-y
 current-mouse-pressed current-mouse-released
 current-mouse-moved current-mouse-dragged
 current-mouse-left-pressed current-mouse-middle-pressed current-mouse-right-pressed
 current-mouse-button
 current-key current-key-pressed current-key-released
 current-draw
 current-on-mouse-pressed current-on-mouse-released
 current-on-mouse-moved current-on-mouse-dragged
 current-on-key-pressed current-on-key-released
 current-on-resize
 current-fill current-stroke-enabled?
 current-ellipse-mode current-rect-mode current-image-mode
 current-color-mode
 current-no-gui
 milliseconds-at-start-of-program reset-milliseconds-at-start-of-program!
 milliseconds-at-start-of-frame reset-milliseconds-at-start-of-frame!
 delta-time reset-delta-time!
 )

(require racket/draw
         racket/class)

(define current-dc (make-parameter #f))

(define-syntax-rule (with-dc dc body ...)
  (parameterize ([current-dc dc]) body ...))

(define current-width  (make-parameter 100))
(define current-height (make-parameter 100))
(define current-density (make-parameter 1))

(define pixel-width  100)
(define pixel-height 100)
(define (set-pixel-width!  v) (set! pixel-width  v))
(define (set-pixel-height! v) (set! pixel-height v))

(define current-frame-count        (make-parameter 0))
(define current-frame-rate         (make-parameter 60))
(define current-actual-frame-rate  (make-parameter 0.0))
(define current-loop-running?      (make-parameter #t))

(define current-mouse-x (make-parameter 0))
(define current-mouse-y (make-parameter 0))
(define current-pmouse-x (make-parameter 0))
(define current-pmouse-y (make-parameter 0))
(define current-mouse-pressed  (make-parameter #f))
(define current-mouse-released (make-parameter #f))
(define current-mouse-moved    (make-parameter #f))
(define current-mouse-dragged  (make-parameter #f))
(define current-mouse-left-pressed   (make-parameter #f))
(define current-mouse-middle-pressed (make-parameter #f))
(define current-mouse-right-pressed  (make-parameter #f))
(define current-mouse-button (make-parameter #f))

(define current-key          (make-parameter #f))
(define current-key-pressed  (make-parameter #f))
(define current-key-released (make-parameter #f))

(define current-draw (make-parameter #f))
(define current-on-mouse-pressed  (make-parameter #f))
(define current-on-mouse-released (make-parameter #f))
(define current-on-mouse-moved    (make-parameter #f))
(define current-on-mouse-dragged  (make-parameter #f))
(define current-on-key-pressed    (make-parameter #f))
(define current-on-key-released   (make-parameter #f))
(define current-on-resize         (make-parameter #f))

;; #f = no fill; otherwise a color%
(define current-fill (make-parameter (make-object color% 255 255 255)))
(define current-stroke-enabled? (make-parameter #t))

(define current-ellipse-mode (make-parameter 'center))
(define current-rect-mode    (make-parameter 'corner))
(define current-image-mode   (make-parameter 'corner))
(define current-color-mode   (make-parameter 'rgb))

(define current-no-gui (make-parameter #f))

(define milliseconds-at-start-of-program 0)
(define (reset-milliseconds-at-start-of-program! v)
  (set! milliseconds-at-start-of-program v))

(define milliseconds-at-start-of-frame 0)
(define (reset-milliseconds-at-start-of-frame! v)
  (set! milliseconds-at-start-of-frame v))

(define delta-time 0)
(define (reset-delta-time! v) (set! delta-time v))
