#lang racket/base
;;; Boot helpers for Rhombus #lang re_sketching (and optional Racket use).
;;; Looks up setup/draw/handlers in the current namespace, then starts the GUI.

(require "state.rkt"
         "gui.rkt")

(provide lookup-proc
         go
         initialize
         start)

(define (lookup-proc name default)
  (namespace-variable-value name #t (lambda () default)))

(define (void-thunk) (void))

(define (go)
  (define setup (or (lookup-proc 'setup #f)
                    (lookup-proc 'Setup #f)
                    void-thunk))
  (define draw  (or (lookup-proc 'draw #f)
                    (lookup-proc 'Draw #f)
                    void-thunk))
  (define on-mouse-pressed
    (or (lookup-proc 'on_mouse_pressed #f)
        (lookup-proc 'on-mouse-pressed #f)
        #f))
  (define on-mouse-released
    (or (lookup-proc 'on_mouse_released #f)
        (lookup-proc 'on-mouse-released #f)
        #f))
  (define on-mouse-moved
    (or (lookup-proc 'on_mouse_moved #f)
        (lookup-proc 'on-mouse-moved #f)
        #f))
  (define on-mouse-dragged
    (or (lookup-proc 'on_mouse_dragged #f)
        (lookup-proc 'on-mouse-dragged #f)
        #f))
  (define on-key-pressed
    (or (lookup-proc 'on_key_pressed #f)
        (lookup-proc 'on-key-pressed #f)
        #f))
  (define on-key-released
    (or (lookup-proc 'on_key_released #f)
        (lookup-proc 'on-key-released #f)
        #f))
  (define on-resize
    (or (lookup-proc 'on_resize #f)
        (lookup-proc 'on-resize #f)
        #f))
  (setup)
  (current-draw (if (procedure? draw) draw void-thunk))
  (current-on-mouse-pressed  (and (procedure? on-mouse-pressed)  on-mouse-pressed))
  (current-on-mouse-released (and (procedure? on-mouse-released) on-mouse-released))
  (current-on-mouse-moved    (and (procedure? on-mouse-moved)    on-mouse-moved))
  (current-on-mouse-dragged  (and (procedure? on-mouse-dragged)  on-mouse-dragged))
  (current-on-key-pressed    (and (procedure? on-key-pressed)    on-key-pressed))
  (current-on-key-released   (and (procedure? on-key-released)   on-key-released))
  (current-on-resize         (and (procedure? on-resize)         on-resize))
  (start-gui)
  (void))

(define (initialize)
  (initialize-gui)
  (void))

(define (start)
  (start-gui)
  (void))
