(in-package :cma-codegen)

(deftype arith-bin-op () '(member :add :sub :mul :div :exp))

(deftype c-variable () '(and symbol (not keyword)))

(defun op->asm (op)
  op)

(defun lookup (rho var)
  (cdr (assoc var rho)))

(defun code-r (expr rho)
  (typecase expr
    (list (destructuring-bind (op . args) expr
            (typecase op
              (arith-bin-op `(,@(code-r (first args) rho)
                              ,@(code-r (second args) rho)
                              ,(op->asm op)))
              ((eql :assign) `(,@(code-r (second args) rho)
                               ,@(code-l (first args) rho)
                               :store))
              ((eql :dot) `(,@(code-l expr rho)
                            :load)))))
    (integer `((:loadc ,expr)))
    (c-variable `(,@(code-l expr rho) :load))))

(defun code-l (expr rho)
  (typecase expr
    (list (destructuring-bind (op . args) expr
            (typecase op
              ((eql :dot) `(,@(code-l (first args) rho)
                            ,@(code-l (second args) rho)
                            :add)))))
    (c-variable `((:loadc ,(lookup rho expr))))))

(defun print-line (line)
  (typecase line
    (list (format t "~{~a~^ ~}~%" line))
    (atom (format t "~a~%" line))))

(defun print-asm (asm)
  (dolist (line asm)
    (print-line line)))

;;; z = (4x^2 + 3x + 1) / (y - 26)
(defparameter *ex1.1-ast*
  '(:assign z (:div (:add (:mul 4 (:mul x x))
                          (:add (:mul 3 x) 1))
                    (:sub y 26))))

(defparameter *ex1.1-asm*
  (code-r *ex1.1-ast* '((x . 100) (y . 101) (z . 102))))

;;; x = ((y = (y+4))*z)
;;; rho = x -> 4, y -> 5, z -> 6
(defparameter *ex2.4-ast*
  '(:assign x (:mul (:assign y
                             (:add y 4))
                    z)))

(defparameter *ex2.4-asm*
  (code-r *ex2.4-ast* '((x . 4) (y . 5) (z . 6))))

;;; a.x.val + a.y
;;; rho = { val -> 0, next -> 1, buffer -> 0, x -> 64, y -> 66, a -> 42 }
(defparameter *ex3.1-ast*
  '(:add (:dot (:dot a x) val)
         (:dot a y)))

(defparameter *ex3.1-rho*
  '((val . 0) (next . 1) (buffer . 0) (x . 64) (y . 66) (a . 42)))

(defparameter *ex3.1-asm*
  (code-r *ex3.1-ast* *ex3.1-rho*))