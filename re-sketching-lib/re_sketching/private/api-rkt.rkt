#lang racket/base
;;; Flat Racket API for Rhombus import via lib(...).

(require "state.rkt"
         "graphics.rkt"
         "transform.rkt"
         "math-lib.rkt"
         "gui.rkt"
         "boot.rkt"
         "color.rkt")

(provide
 ;; boot
 initialize go go-with start lookup-proc
 ;; graphics
 background fill no-fill stroke no-stroke
 stroke-weight stroke-cap stroke-join
 ellipse-mode rect-mode
 point line ellipse circle arc rect square quad triangle
 color red green blue alpha
 ;; transform
 translate rotate scale
 push-matrix pop-matrix reset-matrix
 get-matrix set-matrix
 ;; math
 dist lerp constrain remap norm mag sq radians degrees
 pi π pi/2 π/2 pi/4 π/4 2pi 2π
 (rename-out [new-random random])
 ;; env / gui
 size pixel-density
 loop no-loop no-gui
 cursor no-cursor focused? fullscreen set-title
 actual-frame-rate
 set-frame-rate!
 ;; state getters
 get-width get-height get-frame-count
 get-mouse-x get-mouse-y get-pmouse-x get-pmouse-y
 get-mouse-pressed get-mouse-button
 get-key get-key-pressed get-key-released
 get-pixel-width get-pixel-height
 get-delta-time
 )

(define (get-width) (current-width))
(define (get-height) (current-height))
(define (get-frame-count) (current-frame-count))
(define (get-mouse-x) (current-mouse-x))
(define (get-mouse-y) (current-mouse-y))
(define (get-pmouse-x) (current-pmouse-x))
(define (get-pmouse-y) (current-pmouse-y))
(define (get-mouse-pressed) (current-mouse-pressed))
(define (get-mouse-button) (current-mouse-button))
(define (get-key) (current-key))
(define (get-key-pressed) (current-key-pressed))
(define (get-key-released) (current-key-released))
(define (get-pixel-width) pixel-width)
(define (get-pixel-height) pixel-height)
(define (get-delta-time) delta-time)
