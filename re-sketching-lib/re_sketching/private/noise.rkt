#lang racket/base
;;; Processing-style Perlin noise (1D–3D), multi-octave.
;;; Self-contained — no external package.

(provide noise noise-seed noise-detail)

(require racket/math)

(define perm-size 256)

(define (build-perm seed)
  (define rng (make-pseudo-random-generator))
  (define gen
    (cond
      [seed
       (define s (modulo (inexact->exact (floor seed)) 2147483647))
       (parameterize ([current-pseudo-random-generator rng])
         (random-seed (if (zero? s) 1 s)))
       rng]
      [else (current-pseudo-random-generator)]))
  (define p (build-vector perm-size (λ (i) i)))
  (for ([i (in-range (sub1 perm-size) 0 -1)])
    (define j (parameterize ([current-pseudo-random-generator gen])
                (random (add1 i))))
    (define tmp (vector-ref p i))
    (vector-set! p i (vector-ref p j))
    (vector-set! p j tmp))
  (define p2 (make-vector (* 2 perm-size)))
  (for ([i (in-range perm-size)])
    (define v (vector-ref p i))
    (vector-set! p2 i v)
    (vector-set! p2 (+ i perm-size) v))
  p2)

(define perm (build-perm #f))
(define octaves 4)
(define falloff 0.5)

(define (noise-seed s)
  (set! perm (build-perm s))
  (void))

(define noise-detail
  (case-lambda
    [(lod)
     (set! octaves (max 1 (inexact->exact (round lod))))
     (void)]
    [(lod fall)
     (set! octaves (max 1 (inexact->exact (round lod))))
     (set! falloff fall)
     (void)]))

(define (fade t)
  (* t t t (+ (* t (- (* t 6) 15)) 10)))

(define (lerp a b t)
  (+ a (* t (- b a))))

(define (grad hash x y z)
  (define h (bitwise-and hash 15))
  (define u (if (< h 8) x y))
  (define v (if (< h 4) y (if (or (= h 12) (= h 14)) x z)))
  (+ (if (zero? (bitwise-and h 1)) u (- u))
     (if (zero? (bitwise-and h 2)) v (- v))))

(define (noise3 x y z)
  (define X (bitwise-and (inexact->exact (floor x)) 255))
  (define Y (bitwise-and (inexact->exact (floor y)) 255))
  (define Z (bitwise-and (inexact->exact (floor z)) 255))
  (define xf (- x (floor x)))
  (define yf (- y (floor y)))
  (define zf (- z (floor z)))
  (define u (fade xf))
  (define v (fade yf))
  (define w (fade zf))
  (define A  (+ (vector-ref perm X) Y))
  (define AA (+ (vector-ref perm A) Z))
  (define AB (+ (vector-ref perm (add1 A)) Z))
  (define B  (+ (vector-ref perm (add1 X)) Y))
  (define BA (+ (vector-ref perm B) Z))
  (define BB (+ (vector-ref perm (add1 B)) Z))
  (lerp
   (lerp
    (lerp (grad (vector-ref perm AA) xf yf zf)
          (grad (vector-ref perm BA) (- xf 1) yf zf)
          u)
    (lerp (grad (vector-ref perm AB) xf (- yf 1) zf)
          (grad (vector-ref perm BB) (- xf 1) (- yf 1) zf)
          u)
    v)
   (lerp
    (lerp (grad (vector-ref perm (add1 AA)) xf yf (- zf 1))
          (grad (vector-ref perm (add1 BA)) (- xf 1) yf (- zf 1))
          u)
    (lerp (grad (vector-ref perm (add1 AB)) xf (- yf 1) (- zf 1))
          (grad (vector-ref perm (add1 BB)) (- xf 1) (- yf 1) (- zf 1))
          u)
    v)
   w))

(define (noise-unit x y z)
  (* 0.5 (+ (noise3 x y z) 1.0)))

(define (fbm x y z)
  (let loop ([i 0] [amp 1.0] [freq 1.0] [sum 0.0] [max-amp 0.0])
    (cond
      [(>= i octaves)
       (if (zero? max-amp) 0.0 (/ sum max-amp))]
      [else
       (loop (add1 i)
             (* amp falloff)
             (* freq 2.0)
             (+ sum (* amp (noise-unit (* x freq) (* y freq) (* z freq))))
             (+ max-amp amp))])))

(define noise
  (case-lambda
    [(x)     (fbm (exact->inexact x) 0.0 0.0)]
    [(x y)   (fbm (exact->inexact x) (exact->inexact y) 0.0)]
    [(x y z) (fbm (exact->inexact x) (exact->inexact y) (exact->inexact z))]
    [args (error 'noise "expected 1–3 arguments, got ~a" (length args))]))
