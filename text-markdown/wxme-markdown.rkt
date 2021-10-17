#lang racket/base
(provide wxme->markdown)
(require racket/gui/base racket/class wxme racket/port net/base64)

(define (wxme->markdown bytes)
  (define wport (wxme-port->port (open-input-bytes bytes)))
  (call-with-output-string
    (lambda (out)
      (let loop ([d (read-char-or-special wport)])
        (if (eof-object? d)
            #f
            (begin
              (display
                (cond
                  [(char? d) d]
                  [(is-a? d image-snip%)
                   (bytes-append
                    #"![](data:image/png;base64,"
                    (base64-encode
                     (let ([stream (open-output-bytes)])
                       (send (send d get-bitmap) save-file stream 'png)
                       (get-output-bytes stream))
                     #"")
                    #")")]
                  [else (send d get-text 0 (send d get-count))])
                out)
              (loop (read-char-or-special wport))))))))
