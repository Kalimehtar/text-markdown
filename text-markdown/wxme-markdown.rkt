#lang racket/base
(provide wxme->markdown)
(require racket/gui/base racket/class wxme wxme/editor racket/port net/base64 )

(define (wxme->markdown bytes)
  (define wport (wxme-port->port (open-input-bytes bytes)))
  (define ((print-out wport) out)
    (let loop ([d (read-char-or-special wport)])
        (cond
          [(eof-object? d) #f]
          [(is-a? d editor%)
           ((print-out (send d get-content-port)) out)
           (loop (read-char-or-special wport))]
          [else
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
           (loop (read-char-or-special wport))])))
  (call-with-output-string (print-out wport)))