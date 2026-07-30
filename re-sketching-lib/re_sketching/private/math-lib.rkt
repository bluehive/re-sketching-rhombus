#lang racket/base
(require (rename-in racket/math [pi rkt-pi]))

(provide dist lerp constrain remap norm mag sq radians degrees
         pi π pi/2 π/2 pi/4 π/4 2pi 2π
         new-random)

(define pi   rkt-pi)
(define π    rkt-pi)
(define pi/2 (/ rkt-pi 2))
(define π/2  pi/2)
(define pi/4 (/ rkt-pi 4))
(define π/4  pi/4)
(define 2pi  (* 2 rkt-pi))
(define 2π   2pi)

(define (dist x1 y1 x2 y2)
  (define dx (- x2 x1))
  (define dy (- y2 y1))
  (sqrt (+ (* dx dx) (* dy dy))))

(define (lerp a b t)
  (+ a (* t (- b a))))

(define (constrain v lo hi)
  (max lo (min hi v)))

(define (norm v start stop)
  (if (= start stop) 0.0
      (/ (- v start) (- stop start))))

(define (remap v start1 stop1 start2 stop2)
  (lerp start2 stop2 (norm v start1 stop1)))

(define (mag x y)
  (sqrt (+ (* x x) (* y y))))

(define (sq x) (* x x))

(define (radians deg) (* deg (/ rkt-pi 180.0)))
(define (degrees rad) (* rad (/ 180.0 rkt-pi)))

(define new-random
  (case-lambda
    [() (random)]
    [(hi) (* (random) hi)]
    [(lo hi) (+ lo (* (random) (- hi lo)))]))
