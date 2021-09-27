#lang racket/base
(require racket/gui/base  racket/contract racket/unit racket/class
         "markdown-sig.rkt" "default-gui-unit.rkt" "markdown-unit.rkt" "wxme-markdown.rkt")
(provide (contract-out [insert-xexpr (-> (is-a?/c text%) list? void?)]
                       [insert-markdown (-> (is-a?/c text%) string? void?)]
                       [text%->markdown (-> (is-a?/c text%) string?)]))
(define-compound-unit/infer main@
    (import)
    (export markdown^)
    (link default-gui@
          markdown@))
(define-values/invoke-unit/infer main@)

(define (text%->markdown text)
  (define str (open-output-string))
  (send text save-port str)
  (wxme->markdown (get-output-bytes str)))
