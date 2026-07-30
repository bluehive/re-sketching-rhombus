#lang racket/base
;;; Unit tests: noise + bezier/begin-shape (offscreen, no GUI loop).
(require rackunit
         racket/list
         racket/draw
         racket/class
         re_sketching/private/noise
         re_sketching/private/state
         re_sketching/private/graphics)

(noise-seed 99)
(define samples (for/list ([i 30]) (noise (/ i 7.0) (/ i 11.0))))
(check-true (andmap (λ (n) (and (real? n) (<= 0.0 n 1.0))) samples))
(check-true (> (length (remove-duplicates
                        (map (λ (n) (real->decimal-string n 5)) samples)))
               1))
(define a (noise 1.25))
(check-equal? a (noise 1.25))

(define bm (make-bitmap 120 120))
(define d (new bitmap-dc% [bitmap bm]))
(current-dc d)
(current-width 120)
(current-height 120)
(check-not-exn (λ () (background 200)))
(check-not-exn (λ () (no-fill) (stroke 0) (bezier 10 60 30 10 90 110 110 60)))
(check-not-exn
 (λ ()
   (begin-shape)
   (vertex 20 20)
   (vertex 100 20)
   (vertex 60 100)
   (end-shape 'close)))
(check-not-exn
 (λ ()
   (begin-shape 'lines)
   (vertex 0 0) (vertex 10 10)
   (vertex 20 0) (vertex 30 10)
   (end-shape)))

(printf "tests/noise-shape-unit.rkt: all passed\n")
