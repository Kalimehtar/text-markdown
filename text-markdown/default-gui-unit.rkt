#lang racket/unit
(require "gui-sig.rkt" racket/gui/base racket/class images/icons/symbol)
(import)
(export gui^)

(define (insert-string text string) (send text insert string))
(define (insert-image text bytes) (send text insert
                                        (make-object image-snip%
                                          (make-object bitmap% (open-input-bytes bytes)))))


(define quote-img (text-icon "”"
                             (make-font #:weight 'bold #:family 'decorative)
                             #:color "red" #:height 12))

(define (insert-blockquote text inserter)
  (define t (new text% [auto-wrap #t]))
  (define snip (new editor-snip% [editor t] [with-border? #f]))
  (send t insert (make-object image-snip% quote-img))
  (inserter t)
  (send text insert snip)
  (send text insert "\n"))