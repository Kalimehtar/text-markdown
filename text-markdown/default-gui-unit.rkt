#lang racket/unit
(require "gui-sig.rkt" racket/gui/base racket/class)
(import)
(export gui^)

(define (insert-string text string) (send text insert-string string))
(define (insert-image text bytes) (send text
                                        insert
                                        (make-object image-snip%
                                          (make-object bitmap% (open-input-bytes bytes)))))