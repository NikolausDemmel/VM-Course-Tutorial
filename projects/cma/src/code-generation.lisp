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
                               :store)))))
    (integer `((:loadc ,expr)))
    (c-variable `(,@(code-l expr rho) :load))))

(defun code-l (expr rho)
  (typecase expr
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