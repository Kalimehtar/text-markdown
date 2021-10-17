#lang racket/unit
(require "markdown-sig.rkt" "gui-sig.rkt" racket/match (only-in xml valid-char?) net/base64 markdown)
(import gui^)
(export markdown^)

(define (insert-markdown text string)
  (map (insert-xexpr text) (parse-markdown string))
  (void))

(define ((insert-xexpr text) xexpr)
  (match xexpr
    [(list symbol (list (list attr val) ...) next ...)
     (insert-tag text symbol (map cons attr val) next)]
    [(list symbol next ...)
     (insert-tag text symbol null next)]
    [(? string? s) (insert-string text s)]
    [(? valid-char? c) (insert-string text (string (integer->char c)))]
    [else (void)]))

(define (insert-tag text tag attrs exprs)
  (case tag
    [(img)
     (define src (assq 'src attrs))
     (when src
       (define prefix "data:image/png;base64, ")
       (define l (string-length prefix))
       (define s (cdr src))
       (when (string=? (substring s 0 l) prefix)
         (insert-image text (base64-decode (string->bytes/utf-8 (substring s l))))))]
    [else (map (insert-xexpr text) exprs)]))
