(in-package :cl-user)

(asdf:defsystem cma
  :name "cma"
  :author "Nikolaus Demmel <demmeln@cs.tum.edu>"
  :version "0.1"
  :maintainer "Nikolaus Demmel <demmeln@cs.tum.edu>"
  :licence "BSD"
  :description "CMA goodness"
  :long-description "Translation of a subset of C in CMA assembler and VM for CMA code."

  :depends-on ()
  :components
  ((:module "src"
    :components
    ((:file "packages")
     (:file "code-generation" :depends-on ("packages"))))))