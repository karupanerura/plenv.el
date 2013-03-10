Configuration
=============

In your .emacs.d/init.el:

    (require 'plenv)
    (plenv-global "perl-5.12.3") ;; initialize perl version to use

Use with flymake-perl
=============

In your .emacs.d/init.el:

    (require 'plenv) ;; for guess-plenv-perl-path
    (require 'flymake)

    (defconst flymake-allowed-perl-file-name-masks
      '(("\\.pl$"    flymake-perl-init)
        ("\\.pm$"   flymake-perl-init)
        ("\\.psgi$" flymake-perl-init)
        ("\\.t$"    flymake-perl-init)))

    (defun flymake-perl-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-with-folder-structure))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list (guess-plenv-perl-path) (list "-wc" local-file))))

Commands
========

* plenv (args): M-x plenv <RET> (same arguments as plenv)
* plenv-list (): M-x plenv-list <RET>
* plenv-version (): M-x plenv-version <RET>
* plenv-global (version): M-x plenv-global <RET> perl-5.13.11
* plenv-local (version): M-x plenv-local <RET> perl-5.13.11
* plenv-shell (version): M-x plenv-shell <RET> perl-5.13.11

Utilities
========

* guess-plenv-version (&optional pwd)
* guess-plenv-perl-path (&optional pwd)
