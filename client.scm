#!/usr/bin/guile \
-e main -s
!#
(use-modules (rnrs bytevectors))
(use-modules (rnrs io ports))
(define (main args)
  (let ([s (socket PF_INET SOCK_STREAM 0)]
	[host (if (> (length args) 1)
		  (cadr args)
		  "127.0.0.1")]
	[port (if (> (length args) 2)
		  (caddr args)
		  "2904")])
    (connect s AF_INET (inet-pton AF_INET host) (string->number port))
    (let ((data (get-bytevector-all s)))
      (display (car (bytevector->uint-list
		     data
		     'big
		     4)))
      (newline))
    ))
