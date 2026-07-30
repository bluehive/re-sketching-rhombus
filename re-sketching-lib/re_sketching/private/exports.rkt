#lang racket/base
(require (for-syntax racket/base syntax/parse)
         racket/base
         "state.rkt"
         "graphics.rkt"
         "transform.rkt"
         "math-lib.rkt"
         "noise.rkt"
         "gui.rkt"
         "color.rkt")

(provide
 (except-out (all-from-out racket/base)
             #%module-begin
             #%top
             random)
 (rename-out [re-sketching-module-begin #%module-begin]
             [re-sketching-top          #%top]
             [new-random                random])
 initialize start
 ;; graphics
 background fill no-fill stroke no-stroke
 stroke-weight stroke-cap stroke-join
 ellipse-mode rect-mode
 point line ellipse circle arc rect square quad triangle
 bezier begin-shape end-shape vertex
 color red green blue alpha
 ;; transform
 translate rotate scale push-matrix pop-matrix reset-matrix
 get-matrix set-matrix
 ;; math
 dist lerp constrain remap norm mag sq radians degrees
 pi π pi/2 π/2 pi/4 π/4 2pi 2π
 noise noise-seed noise-detail
 ;; environment / gui
 size pixel-density
 loop no-loop no-gui
 cursor no-cursor focused? fullscreen set-title
 actual-frame-rate
 frame-rate
 ;; system variables
 width height frame-count
 mouse-x mouse-y pmouse-x pmouse-y
 mouse-button mouse-pressed
 key key-pressed key-released
 delta-time-id
 pixel-width pixel-height
 )

;;; System variables as bare identifiers
(define-syntax (width stx)
  (syntax-case stx ()
    [_ #'(current-width)]))
(define-syntax (height stx)
  (syntax-case stx ()
    [_ #'(current-height)]))
(define-syntax (frame-count stx)
  (syntax-case stx ()
    [_ #'(current-frame-count)]))
(define-syntax (mouse-x stx)
  (syntax-case stx ()
    [_ #'(current-mouse-x)]))
(define-syntax (mouse-y stx)
  (syntax-case stx ()
    [_ #'(current-mouse-y)]))
(define-syntax (pmouse-x stx)
  (syntax-case stx ()
    [_ #'(current-pmouse-x)]))
(define-syntax (pmouse-y stx)
  (syntax-case stx ()
    [_ #'(current-pmouse-y)]))
(define-syntax (mouse-button stx)
  (syntax-case stx ()
    [_ #'(current-mouse-button)]))
(define-syntax (mouse-pressed stx)
  (syntax-case stx ()
    [_ #'(current-mouse-pressed)]))
(define-syntax (key stx)
  (syntax-case stx ()
    [_ #'(current-key)]))
(define-syntax (key-pressed stx)
  (syntax-case stx ()
    [_ #'(current-key-pressed)]))
(define-syntax (key-released stx)
  (syntax-case stx ()
    [_ #'(current-key-released)]))
(define-syntax (delta-time-id stx)
  (syntax-case stx ()
    [_ #'delta-time]))

(define-syntax (frame-rate stx)
  (syntax-parse stx
    [(_ fps) #'(set-frame-rate! fps)]
    [id:id #'(actual-frame-rate)]))

(define (initialize)
  (initialize-gui)
  (void))

(define (start)
  (start-gui)
  (void))

(define-syntax (re-sketching-top stx)
  (syntax-parse stx
    [(top . id)
     (case (syntax-e #'id)
       [(setup)             #'default-setup]
       [(draw)              #'default-draw]
       [(on-mouse-pressed)  #'#f]
       [(on-mouse-released) #'#f]
       [(on-mouse-moved)    #'#f]
       [(on-mouse-dragged)  #'#f]
       [(on-key-pressed)    #'#f]
       [(on-key-released)   #'#f]
       [(on-resize)         #'#f]
       [else #'(#%top . id)])]))

(define (default-setup) (void))
(define (default-draw) (void))

(define-syntax (re-sketching-module-begin stx)
  (syntax-parse stx
    [(_ form ...)
     (define forms (syntax->list #'(form ...)))
     (define ctx (if (null? forms) stx (car forms)))
     (with-syntax ([initialize (datum->syntax ctx 'initialize)]
                   [setup (datum->syntax ctx 'setup)]
                   [draw (datum->syntax ctx 'draw)]
                   [on-mouse-pressed (datum->syntax ctx 'on-mouse-pressed)]
                   [on-mouse-released (datum->syntax ctx 'on-mouse-released)]
                   [on-mouse-moved (datum->syntax ctx 'on-mouse-moved)]
                   [on-mouse-dragged (datum->syntax ctx 'on-mouse-dragged)]
                   [on-key-pressed (datum->syntax ctx 'on-key-pressed)]
                   [on-key-released (datum->syntax ctx 'on-key-released)]
                   [on-resize (datum->syntax ctx 'on-resize)]
                   [start (datum->syntax ctx 'start)]
                   [default-setup (datum->syntax ctx 'default-setup)]
                   [default-draw (datum->syntax ctx 'default-draw)])
       (syntax/loc stx
         (#%module-begin
          (initialize)
          form ...
          (define (default-setup) (void))
          (define (default-draw) (void))
          (setup)
          (current-draw draw)
          (current-on-mouse-pressed  on-mouse-pressed)
          (current-on-mouse-released on-mouse-released)
          (current-on-mouse-moved    on-mouse-moved)
          (current-on-mouse-dragged  on-mouse-dragged)
          (current-on-key-pressed    on-key-pressed)
          (current-on-key-released   on-key-released)
          (current-on-resize         on-resize)
          (start))))]))
