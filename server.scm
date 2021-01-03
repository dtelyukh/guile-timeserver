#!/usr/bin/guile \
-e main -s
!#
(use-modules (rnrs bytevectors))
(use-modules (rnrs io ports))
(define (main args)
  (let ([s (socket PF_INET SOCK_STREAM 0)]
	[port (if (> (length args) 1)
		  (cadr args)
		  "2904")])
    (setsockopt s SOL_SOCKET SO_REUSEADDR 1)
    (bind s AF_INET INADDR_ANY (string->number port))
    (listen s 5)

    (simple-format #t "Listening for clients in pid: ~S" (getpid))
    (newline)

    (while #t
      (let* ((client-connection (accept s))
	     (client-details (cdr client-connection))
	     (client (car client-connection)))
	(simple-format #t "Got new client connection: ~S"
		       client-details)
	(newline)
	(simple-format #t "Client address: ~S"
		       (gethostbyaddr
			(sockaddr:addr client-details)))
	(newline)
	(put-bytevector client
			(uint-list->bytevector
			 (cons (current-time) '())
			 'big
			 4))
	(close client)))))
