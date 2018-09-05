(in-package #:house)

(defparameter *sessions* (make-hash-table :test 'equal :size 2000))
(defparameter *new-session-hook* nil)

(defmethod new-session-hook! ((callback function))
  (push callback *new-session-hook*))

(defun clear-session-hooks! ()
  (setf *new-session-hook* nil))

(let ((gen nil))
  (defun new-session-token! ()
    (unless gen
      (setf gen (session-token:make-generator
		 :token-length 64
		 :initial-seed #-windows (session-token:init-kernel-seed) #+windows (session-token:init-common-lisp-random-seed))))
    #+windows (warn "Running on Windows; using insecure session tokens")
    (funcall gen)))

(defun new-session! ()
  (when (zerop (random +clean-sessions-every+))
    (clean-sessions!))
  (let ((session (make-instance 'session :token (new-session-token!))))
    (setf (gethash (token session) *sessions*) session)
    (loop for hook in *new-session-hook*
       do (funcall hook session))
    session))

(defun idling? (sess)
  (> (- (get-universal-time) (slot-value sess 'last-poked)) +max-session-idle+))

(defun get-session! (token)
  (when-let (session (gethash token *sessions*))
    (if (idling? session)
	(and (remhash token *sessions*) nil)
	(poke! session))))

(defun clean-sessions! ()
  (loop for k being the hash-keys of *sessions*
     for v being the hash-values of *sessions*
     when (idling? v) do (remhash k *sessions*)))

(defmethod poke! ((sess session))
  (setf (slot-value sess 'last-poked) (get-universal-time))
  sess)
