#lang Racket

(require racket-cord)
 
(define bot-token (getenv "BOT_TOKEN"))
 
(define myclient (make-client bot-token #:auto-shard #t))
 
(on-event
  'message-create myclient
  (lambda (client message)
    (unless (string=? (user-id (message-author message))
                      (user-id (client-user client)))
      (cond
        [(string-prefix? (message-content message) "!echo ")
         (http:create-message client (message-channel-id message)
                              (string-trim (message-content message) "!echo " #:right? #f))]))))
 
 
 
(define dr (make-log-receiver discord-logger 'debug))
 
(thread
  (thunk
    (let loop ()
      (let ([v (sync dr)])
        (printf "[~a] ~a\n" (vector-ref v 0)
                (vector-ref v 1)))
      (loop))))
 
(start-client myclient)