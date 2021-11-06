#lang racket/signature
(require racket/gui/base racket/class)
(contracted
 [insert-string (-> (is-a?/c text%) string? any)]
 [insert-image (-> (is-a?/c text%) bytes? any)]
 [insert-blockquote (-> (is-a?/c text%) (-> (is-a?/c text%) any) any)])
