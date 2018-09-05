(defsystem "house"
  :description "Custom asynchronous HTTP server for the Deal project."
  :author "Inaimathi <leo.zovic@gmail.com>"
  :license "AGPL3"
  :serial t
  :depends-on ("alexandria"
	       "bordeaux-threads"
               "usocket"
               "flexi-streams"
	       "cl-fad"
               "cl-ppcre"
               "optima"
               "cl-json"
               "split-sequence"
	       "session-token"
               "trivial-features")
  :components ((:file "package")
	       (:file "model")
	       (:file "handler-table")
	       (:file "util")
	       (:file "define-handler")
	       (:file "session")
	       (:file "house")))

(defsystem "house/tests"
  :serial t
  :depends-on ("house"
               "lisp-unit")
  :components ((:file "unit-tests")))
