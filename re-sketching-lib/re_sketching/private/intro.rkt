#lang racket/base
;;; Hygiene helpers: build identifiers with a given lexical context.
(require (for-syntax racket/base))
(provide contextual-id
         contextual-id*)

;; ctx-stx: any syntax whose lexical context we copy
;; sym: symbol or identifier
(define (contextual-id ctx-stx sym)
  (define s (if (syntax? sym) (syntax-e sym) sym))
  (datum->syntax ctx-stx s ctx-stx))

;; For use when we only have a list of forms; use the first form or a
;; synthetic multi as context.
(define (contextual-id* forms-stx sym)
  (define ctx
    (cond
      [(syntax? forms-stx)
       (define d (syntax-e forms-stx))
       (cond
         [(and (pair? d) (syntax? (car d))) (car d)]
         [else forms-stx])]
      [(and (pair? forms-stx) (syntax? (car forms-stx))) (car forms-stx)]
      [else #f]))
  (contextual-id ctx sym))
