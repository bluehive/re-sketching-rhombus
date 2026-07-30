#lang info

(define collection 'multi)

(define deps
  '("base"
    "draw-lib"
    "gui-lib"
    "math-lib"
    "rhombus-lib"
    "shrubbery-lib"))

(define build-deps '())

(define pkg-desc "Processing-style creative coding for Racket/Rhombus (implementation)")

(define pkg-authors '(bluehive grok))

(define version "0.2")

(define license 'MIT)

(define language-families '("Rhombus"))
