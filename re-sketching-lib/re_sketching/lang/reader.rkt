#lang s-exp syntax/module-reader
re_sketching/rhombus_lang
#:read (lambda (in) (list (syntax->datum (parse-all in))))
#:read-syntax (lambda (src in) (list (parse-all in #:source src)))
#:info get-info-proc
#:whole-body-readers? #t
(require shrubbery/parse
         (only-in (submod rhombus/private/core reader) get-info-proc))
