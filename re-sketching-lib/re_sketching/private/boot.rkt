#lang racket/base
;;; Boot helpers for #lang re_sketching.
;;; Rhombus `fun` bindings are NOT visible via namespace-variable-value,
;;; so setup/draw must be passed as procedure values from the language layer.

(require "state.rkt"
         "gui.rkt")

(provide lookup-proc
         go
         go-with
         initialize
         start)

(define (lookup-proc name default)
  ;; Racket-surface fallback only; Rhombus funs are not found this way.
  (namespace-variable-value name #t (lambda () default)))

(define (void-thunk) (void))

(define (as-proc v)
  (and (procedure? v) v))

(define (go-with setup
                 draw
                 [on-mouse-pressed #f]
                 [on-mouse-released #f]
                 [on-mouse-moved #f]
                 [on-mouse-dragged #f]
                 [on-key-pressed #f]
                 [on-key-released #f]
                 [on-resize #f])
  (define s (or (as-proc setup) void-thunk))
  (define d (or (as-proc draw) void-thunk))
  (s)
  (current-draw d)
  (current-on-mouse-pressed  (as-proc on-mouse-pressed))
  (current-on-mouse-released (as-proc on-mouse-released))
  (current-on-mouse-moved    (as-proc on-mouse-moved))
  (current-on-mouse-dragged  (as-proc on-mouse-dragged))
  (current-on-key-pressed    (as-proc on-key-pressed))
  (current-on-key-released   (as-proc on-key-released))
  (current-on-resize         (as-proc on-resize))
  (start-gui)
  (void))

;; Legacy: namespace lookup (works for #lang re_sketching/racket)
(define (go)
  (define setup (or (lookup-proc 'setup #f)
                    (lookup-proc 'Setup #f)
                    void-thunk))
  (define draw  (or (lookup-proc 'draw #f)
                    (lookup-proc 'Draw #f)
                    void-thunk))
  (go-with setup
           draw
           (or (lookup-proc 'on_mouse_pressed #f)
               (lookup-proc 'on-mouse-pressed #f))
           (or (lookup-proc 'on_mouse_released #f)
               (lookup-proc 'on-mouse-released #f))
           (or (lookup-proc 'on_mouse_moved #f)
               (lookup-proc 'on-mouse-moved #f))
           (or (lookup-proc 'on_mouse_dragged #f)
               (lookup-proc 'on-mouse-dragged #f))
           (or (lookup-proc 'on_key_pressed #f)
               (lookup-proc 'on-key-pressed #f))
           (or (lookup-proc 'on_key_released #f)
               (lookup-proc 'on-key-released #f))
           (or (lookup-proc 'on_resize #f)
               (lookup-proc 'on-resize #f))))

(define (initialize)
  (initialize-gui)
  (void))

(define (start)
  (start-gui)
  (void))
