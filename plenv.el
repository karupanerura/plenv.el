;;; plenv.el --- A plenv wrapper for Emacs

;; Copyright (C) 2012 Kenta Sato

;; Author: Kenta Sato <karupa@cpan.org>
;; Version: 0.1
;; Keywords: Emacs, Perl

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Initialize
;; (require 'plenv)
;; (plenv-global "perl-5.16.2") ;; initialize perl version to use

;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;; `plenv-dir'
;; your perlbrew directory
;; default = ~/.plenv

;;; Code:
(require 'cl)

(defgroup plenv nil
  "plenv"
  :group 'shell)

(defcustom plenv-dir (concat (getenv "HOME") "/.plenv")
  "your plenv directory"
  :group 'plenv)

(defvar plenv-versions-dir nil)
(defvar plenv-command-path nil)

(defvar plenv-current-perl-dir nil)
(defvar plenv-current-perl-path nil)

(defmacro plenv-trim (str)
  `(replace-regexp-in-string "\n+$" "" ,str))

(defmacro plenv-join (delimiter string-list)
  `(mapconcat 'identity ,string-list ,delimiter))

(defmacro plenv-command (args)
  `(plenv-join " " (cons "plenv" ,args)))

(defun plenv-perls ()
  (let* ((perls (split-string (plenv "list")))
          (valid-perls (remove-if-not
                       (lambda (i)
                         (string-match "^\\(perl\\|[0-9]\\)" i))
                       perls)))
    (append valid-perls (list "system"))))

(defun plenv (args)
  (interactive "M$ plenv ")
  (let* ((command (plenv-command (list args)))
         (result (plenv-trim (shell-command-to-string command))))
    (if (called-interactively-p 'interactive)
        (unless (string-match "^\\s*$" result) (message result))
      result)))

(defun plenv-list ()
  (interactive)
  (shell-command (plenv-command '("list"))))

(defun plenv-shell (version)
  (interactive (list (completing-read "Version: " (plenv-perls) nil t)))
  (setq plenv-versions-dir (concat plenv-dir "/versions"))
  (unless (called-interactively-p 'interactive)
    (unless (member version (plenv-perls))
      (error "Not installed version: %s" version)))
  (setenv "PLENV_VERSION" version))

(defun plenv-local (version)
  (interactive (list (completing-read "Version: " (plenv-perls) nil t)))
  (setq plenv-versions-dir (concat plenv-dir "/versions"))
  (unless (called-interactively-p 'interactive)
    (unless (member version (plenv-perls))
      (error "Not installed version: %s" version)))
  (shell-command (plenv-command (list "local" version))))

(defun plenv-global (version)
  (interactive (list (completing-read "Version: " (plenv-perls) nil t)))
  (setq plenv-versions-dir (concat plenv-dir "/versions"))
  (unless (called-interactively-p 'interactive)
    (unless (member version (plenv-perls))
      (error "Not installed version: %s" version)))
  (shell-command (plenv-command (list "global" version))))

(provide 'plenv)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions)
;; End:

;;; plenv.el ends here