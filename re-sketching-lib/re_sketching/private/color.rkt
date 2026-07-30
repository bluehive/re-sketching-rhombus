#lang racket/base
(require racket/draw
         racket/class
         racket/match
         racket/string
         "state.rkt")

(provide args->color color? make-gray-color named-color)

(define (color? x)
  (and (object? x) (is-a? x color%)))

(define (clamp-byte n)
  (inexact->exact (max 0 (min 255 (round n)))))

(define (make-gray-color g [a 1.0])
  (define v (clamp-byte g))
  (make-object color% v v v a))

(define named-colors
  (hash
   "black"   (make-object color% 0 0 0)
   "white"   (make-object color% 255 255 255)
   "red"     (make-object color% 255 0 0)
   "green"   (make-object color% 0 255 0)
   "blue"    (make-object color% 0 0 255)
   "yellow"  (make-object color% 255 255 0)
   "cyan"    (make-object color% 0 255 255)
   "magenta" (make-object color% 255 0 255)
   "orange"  (make-object color% 255 165 0)
   "gray"    (make-object color% 128 128 128)
   "grey"    (make-object color% 128 128 128)))

(define (named-color s)
  (hash-ref named-colors (string-downcase s) #f))

(define (args->color args [who 'color])
  (match args
    [(list (? color? c)) c]
    [(list (? string? s))
     (or (named-color s)
         (with-handlers ([exn:fail? (λ (_) (make-object color% 0 0 0))])
           (make-object color% s)))]
    [(list (? real? g))
     (make-gray-color g)]
    [(list (? real? g) (? real? a))
     ;; gray + alpha: Processing uses 0-255 alpha often
     (define alpha (if (<= a 1.0) a (/ a 255.0)))
     (make-gray-color g alpha)]
    [(list (? real? r) (? real? g) (? real? b))
     (make-object color% (clamp-byte r) (clamp-byte g) (clamp-byte b))]
    [(list (? real? r) (? real? g) (? real? b) (? real? a))
     (define alpha (if (<= a 1.0) a (/ a 255.0)))
     (make-object color% (clamp-byte r) (clamp-byte g) (clamp-byte b) alpha)]
    [else
     (error who "bad color arguments: ~a" args)]))
