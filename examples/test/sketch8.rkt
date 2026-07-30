#lang re_sketching/racket
;; Matrix stack: translate + push/pop.

(define (setup)
  (size 200 200))

(define (draw)
  (background (* 3 64))
  (stroke 0)

  (fill 255)
  (rect 0 0 50 50) ; white

  (push-matrix)
  (translate 30 20)
  (fill 0)
  (rect 0 0 50 50) ; black
  (pop-matrix)

  (fill 100)
  (rect 15 10 50 50)) ; gray
