#lang racket/unit
(require "markdown-sig.rkt" "gui-sig.rkt" racket/match (only-in xml valid-char?) net/base64 markdown)
(import gui^)
(export markdown^)

(define prefix "data:image/png;base64,")
(define prefix-length (string-length prefix))

(define (insert-markdown text string)
  (map (insert-xexpr text) (parse-markdown string))
  (void))

(define (insert-markdown-source text string)
  (define l (string-length string))
  (define prefix-length* (+ prefix-length (string-length "![](")))
  (let loop ([begin 0] [positions (regexp-match-positions* #rx"!\\[\\]\\(data:image/png;base64,.*?\\)" string)])
    (cond
      [(null? positions)
       (when (< begin l)
         (insert-string text (substring string begin (string-length string))))]
      [else
       (match-define (cons (cons a b) rest) positions)
       (insert-image text (base64-decode (string->bytes/utf-8 (substring string (+ a prefix-length*) (- b 1)))))
       (loop b rest)]))
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
       (define s (cdr src))
       (when (string=? (substring s 0 prefix-length) prefix)
         (insert-image text (base64-decode (string->bytes/utf-8 (substring s prefix-length))))))]
    [else (map (insert-xexpr text) exprs)]))
