#lang racket/base
(require racket/class
         "state.rkt")

(provide translate rotate scale
         push-matrix pop-matrix reset-matrix
         get-matrix set-matrix)

(define matrix-stack '())

(define (dc)
  (define d (current-dc))
  (unless d (error 'transform "no drawing context"))
  d)

(define (translate x y)
  (send (dc) transform (vector 1 0 0 1 x y)))

(define (rotate angle)
  ;; Processing: positive angles rotate clockwise in default 2D;
  ;; racket/draw rotate is counter-clockwise for positive.
  ;; Match Processing/Sketching: negate.
  (send (dc) rotate (- angle)))

(define scale
  (case-lambda
    [(s) (send (dc) scale s s)]
    [(sx sy) (send (dc) scale sx sy)]))

(define (push-matrix)
  (set! matrix-stack (cons (send (dc) get-transformation) matrix-stack)))

(define (pop-matrix)
  (when (null? matrix-stack)
    (error 'pop-matrix "stack empty"))
  (send (dc) set-transformation (car matrix-stack))
  (set! matrix-stack (cdr matrix-stack)))

(define (reset-matrix)
  (send (dc) set-transformation
        (vector (vector 1 0 0 1 0 0) 0 0 1 1 0)))

(define (get-matrix)
  (send (dc) get-transformation))

(define (set-matrix t)
  (send (dc) set-transformation t))
