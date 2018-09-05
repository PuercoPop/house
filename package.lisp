(defpackage #:house
  (:use #:cl
        #:optima
        #:cl-ppcre
        #:usocket
        #:alexandria)
  (:import-from #:flexi-streams
                #:octet)
  (:export #:define-handler
           #:define-json-handler

           #:define-redirect-handler
           #:redirect!
           #:define-file-handler

           #:define-http-type
           #:parameter
           #:restrictions

           #:request
           #:resource
           #:headers
           #:session-tokens
           #:parameters

           #:assert-http
           #:root
           #:sock
           #:session
           #:parameters
           #:new-session!
           #:new-session-hook!
           #:clear-session-hooks!
           #:get-session!
           #:lookup
           #:path->uri
           #:subscribe!
           #:publish!
           #:make-sse
           #:start))

(in-package #:house)

(declaim (inline crlf write-ln idling? flex-stream))

(setf *random-state* (make-random-state t))

(defparameter *cookie-domains* nil)

(defparameter +max-request-size+ 50000)
(defparameter +max-buffer-tries+ 10)
(defparameter +max-request-age+ 30)

(defparameter +max-session-idle+ (* 30 60))
(defparameter +clean-sessions-every+ 10000)
