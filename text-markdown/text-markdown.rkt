#lang racket/base
(require racket/match xml racket/class racket/gui/base net/base64)

(define ((insert-xexpr text) xexpr)
  (match xexpr
    [(list symbol (list (list attr val) ...) next ...)
     (insert-tag text symbol (map cons attr val) next)]
    [(list symbol next ...)
     (insert-tag text symbol null next)]
    [(? string? s) (send text insert-string s)]
    [(? valid-char? c) (send text insert-string (string (integer->char c)))]
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
         (send text
               insert
               (make-object image-snip%
                 (make-object bitmap%
                   (open-input-bytes (base64-decode (string->bytes/utf-8 (substring s l)))))))))]
    [else (map (insert-xexpr text) exprs)]))
  