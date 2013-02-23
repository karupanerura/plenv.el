Configuration
=============

In your .emacs:

    (require 'plenv)
    (plenv-global "perl-5.12.3") ;; initialize perl version to use
        
Commands
========

* plenv (args): M-x plenv <RET> (same arguments as plenv)
* plenv-list (): M-x plenv-list <RET>
* plenv-global (version): M-x plenv-global <RET> perl-5.13.11
* plenv-local (version): M-x plenv-local <RET> perl-5.13.11
* plenv-shell (version): M-x plenv-shell <RET> perl-5.13.11
