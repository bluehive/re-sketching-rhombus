#lang racket/base
(require racket/draw
         racket/class
         racket/math
         "state.rkt"
         "color.rkt")

(provide background fill no-fill stroke no-stroke
         stroke-weight stroke-cap stroke-join
         ellipse-mode rect-mode
         point line ellipse circle arc rect square quad triangle
         bezier begin-shape end-shape vertex
         color red green blue alpha)

(define transparent-pen (new pen% [style 'transparent]))
(define transparent-brush (new brush% [style 'transparent]))

(define (dc)
  (define d (current-dc))
  (unless d (error 'graphics "no drawing context (call size / start first)"))
  d)

(define (color . args)
  (args->color args 'color))

(define (red c)   (send c red))
(define (green c) (send c green))
(define (blue c)  (send c blue))
(define (alpha c) (send c alpha))

(define (background . args)
  (define c (args->color args 'background))
  (define d (dc))
  (define old-b (send d get-brush))
  (define old-p (send d get-pen))
  (send d set-brush c 'solid)
  (send d set-pen transparent-pen)
  (define t (send d get-transformation))
  (send d set-transformation (vector (vector 1 0 0 1 0 0) 0 0 1 1 0))
  (send d draw-rectangle 0 0 (current-width) (current-height))
  (send d set-transformation t)
  (send d set-brush old-b)
  (send d set-pen old-p)
  (send d set-background c)
  (void))

(define (fill . args)
  (current-fill (args->color args 'fill))
  (void))

(define (no-fill)
  (current-fill #f)
  (void))

(define (stroke . args)
  (current-stroke-enabled? #t)
  (define c (args->color args 'stroke))
  (define d (dc))
  (define old (send d get-pen))
  (send d set-pen (new pen%
                       [color c]
                       [width (send old get-width)]
                       [style 'solid]
                       [cap (send old get-cap)]
                       [join (send old get-join)]))
  (void))

(define (no-stroke)
  (current-stroke-enabled? #f)
  (void))

(define (stroke-weight w)
  (define d (dc))
  (define old (send d get-pen))
  (send d set-pen (new pen%
                       [color (send old get-color)]
                       [width w]
                       [style (if (current-stroke-enabled?) 'solid 'transparent)]
                       [cap (send old get-cap)]
                       [join (send old get-join)]))
  (void))

(define (stroke-cap style)
  (define d (dc))
  (define old (send d get-pen))
  (define cap
    (case style
      [(round) 'round]
      [(square project) 'projecting]
      [(butt) 'butt]
      [else 'round]))
  (send d set-pen (new pen%
                       [color (send old get-color)]
                       [width (send old get-width)]
                       [style (send old get-style)]
                       [cap cap]
                       [join (send old get-join)]))
  (void))

(define (stroke-join style)
  (define d (dc))
  (define old (send d get-pen))
  (define join
    (case style
      [(miter) 'miter]
      [(bevel) 'bevel]
      [(round) 'round]
      [else 'miter]))
  (send d set-pen (new pen%
                       [color (send old get-color)]
                       [width (send old get-width)]
                       [style (send old get-style)]
                       [cap (send old get-cap)]
                       [join join]))
  (void))

(define (ellipse-mode m) (current-ellipse-mode m) (void))
(define (rect-mode m)    (current-rect-mode m) (void))

(define (apply-style)
  (define d (dc))
  (define f (current-fill))
  (if f
      (send d set-brush f 'solid)
      (send d set-brush transparent-brush))
  (define old (send d get-pen))
  (if (current-stroke-enabled?)
      (send d set-pen (new pen%
                           [color (send old get-color)]
                           [width (send old get-width)]
                           [style 'solid]
                           [cap (send old get-cap)]
                           [join (send old get-join)]))
      (send d set-pen transparent-pen)))

(define (mode-box mode x y w h)
  ;; Returns upper-left x,y and width,height for drawing.
  (case mode
    [(center)
     (values (- x (/ w 2.0)) (- y (/ h 2.0)) w h)]
    [(radius)
     (values (- x w) (- y h) (* 2 w) (* 2 h))]
    [(corners)
     (define x2 w) (define y2 h)
     (values (min x x2) (min y y2) (abs (- x2 x)) (abs (- y2 y)))]
    [else ; corner
     (values x y w h)]))

(define (point x y)
  (apply-style)
  (define d (dc))
  (define old (send d get-pen))
  (send d set-pen (new pen%
                       [color (send old get-color)]
                       [width (max 1 (send old get-width))]
                       [style 'solid]))
  (send d draw-point x y)
  (void))

(define (line x1 y1 x2 y2)
  (apply-style)
  (send (dc) draw-line x1 y1 x2 y2)
  (void))

(define (ellipse x y w h)
  (apply-style)
  (define-values (xx yy ww hh) (mode-box (current-ellipse-mode) x y w h))
  (send (dc) draw-ellipse xx yy ww hh)
  (void))

(define (circle x y extent)
  (ellipse x y extent extent))

(define (arc x y w h start stop [mode #f])
  ;; Processing: angles clockwise from 3 o'clock; racket draw-arc is counter-clockwise.
  (apply-style)
  (define-values (xx yy ww hh) (mode-box (current-ellipse-mode) x y w h))
  (define from (- (* 2 pi) stop))
  (define to   (- (* 2 pi) start))
  (when (> from to)
    (set! to (+ to (* 2 pi))))
  (send (dc) draw-arc xx yy ww hh from to)
  (void))

(define (rect x y w h [r #f])
  (apply-style)
  (define-values (xx yy ww hh) (mode-box (current-rect-mode) x y w h))
  (if (and r (positive? r))
      (send (dc) draw-rounded-rectangle xx yy ww hh r)
      (send (dc) draw-rectangle xx yy ww hh))
  (void))

(define (square x y extent)
  (rect x y extent extent))

(define (quad x1 y1 x2 y2 x3 y3 x4 y4)
  (apply-style)
  (send (dc) draw-polygon (list (cons x1 y1) (cons x2 y2) (cons x3 y3) (cons x4 y4)))
  (void))

(define (triangle x1 y1 x2 y2 x3 y3)
  (apply-style)
  (send (dc) draw-polygon (list (cons x1 y1) (cons x2 y2) (cons x3 y3)))
  (void))

;;; ---- curves & freeform shapes (Processing-style) ----

(define (bezier x1 y1 x2 y2 x3 y3 x4 y4)
  (apply-style)
  (define p (new dc-path%))
  (send p move-to x1 y1)
  (send p curve-to x2 y2 x3 y3 x4 y4)
  (send (dc) draw-path p)
  (void))

;; Shape stack: each entry is (kind . rev-points) where rev-points is list of (x . y)
(define shape-stack '())

(define (begin-shape [kind 'default])
  (define k
    (cond
      [(symbol? kind) kind]
      [else 'default]))
  (set! shape-stack (cons (cons k '()) shape-stack))
  (void))

(define (vertex x y)
  (when (null? shape-stack)
    (error 'vertex "no active shape (call begin-shape first)"))
  (define top (car shape-stack))
  (define kind (car top))
  (define rev (cdr top))
  (set! shape-stack
        (cons (cons kind (cons (cons x y) rev))
              (cdr shape-stack)))
  (void))

(define (end-shape [mode #f])
  (when (null? shape-stack)
    (error 'end-shape "no active shape (call begin-shape first)"))
  (define top (car shape-stack))
  (set! shape-stack (cdr shape-stack))
  (define kind (car top))
  (define points (reverse (cdr top)))
  (define close?
    (case mode
      [(close #t) #t]
      [else #f]))
  (apply-style)
  (define d (dc))
  (define x car)
  (define y cdr)
  (cond
    [(null? points) (void)]
    [(eq? kind 'points)
     (for ([p (in-list points)])
       (send d draw-point (x p) (y p)))]
    [(eq? kind 'lines)
     (let loop ([ps points])
       (unless (or (null? ps) (null? (cdr ps)))
         (define p (car ps))
         (define q (cadr ps))
         (send d draw-line (x p) (y p) (x q) (y q))
         (loop (cddr ps))))]
    [(eq? kind 'triangles)
     (let loop ([ps points])
       (unless (< (length ps) 3)
         (define p1 (car ps))
         (define p2 (cadr ps))
         (define p3 (caddr ps))
         (send d draw-polygon
               (list (cons (x p1) (y p1))
                     (cons (x p2) (y p2))
                     (cons (x p3) (y p3))))
         (loop (cdddr ps))))]
    [else ; default: polyline / polygon path
     (define path (new dc-path%))
     (define p1 (car points))
     (send path move-to (x p1) (y p1))
     (for ([p (in-list (cdr points))])
       (send path line-to (x p) (y p)))
     (when close?
       (send path close))
     (send d draw-path path)])
  (void))
