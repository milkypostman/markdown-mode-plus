;;; markdown-mode+.el --- extra functions for markdown-mode

;; Copyright (c) 2011 Donald Ephraim Curtis <dcurtis@milkbox.net>

;; Author: Donald Ephraim Curtis
;; URL: http://github.com/milkypostman/markdown-mode+.el
;; Version:1
;; Keywords: markdown, latex, osx, rtf

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(defcustom markdown-copy-command "pbcopy"
  "Command that takes data as input and copies it to the clipboard."
  :group 'markdown
  :type 'string)


(defcustom markdown-rtf-command "pandoc -s -t rtf"
  "Command to generate RTF from Markdown"
  :group 'markdown
  :type 'string)

(defcustom markdown-latex-command "pandoc -s --mathjax -t latex"
  "Command to output LaTeX from Markdown, output filename is appended."
  :group 'markdown
  :type 'string)

(defun markdown--cleanup-list-numbers-level (&optional pfx)
  "Update the numbering for pfx (as a string of spaces).

Assume that the previously found match was for a numbered item in a list."
  (let ((m pfx)
        (idx 0)
        (success t))
    (while (and success
                (not (string-prefix-p "#" (match-string-no-properties 1)))
                (not (string< (setq m (match-string-no-properties 2)) pfx)))
      (cond
       ((string< pfx m)
        (setq success (markdown--cleanup-list-numbers-level m)))
       (success
        (replace-match
         (concat pfx (number-to-string  (setq idx (1+ idx))) ". "))
        (setq success
              (re-search-forward
               (concat "\\(^#+\\|\\(^\\|^[\s-]*\\)[0-9]+\\. \\)") nil t)))))
    success))

;;;###autoload
(defun markdown-cleanup-list-numbers ()
  "Update the numbering of numbered markdown lists"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward (concat "\\(\\(^[\s-]*\\)[0-9]+\\. \\)") nil t)
      (markdown--cleanup-list-numbers-level (match-string-no-properties 2)))))

;;;###autoload
(defun markdown-export-latex ()
  "Output the Markdown file as LaTeX"
  (interactive)
  (let ((output-file
         (concat
          (or
           (file-name-sans-extension (buffer-file-name))
           (buffer-name)) ".tex")))
    (when output-file
      (let ((output-buffer-name (buffer-name (find-file-noselect output-file)))
            (markdown-command markdown-latex-command))
        (flet ((markdown-output-standalone-p () t))
          (markdown output-buffer-name))
        (with-current-buffer output-buffer-name
          (save-buffer)
          (kill-buffer output-buffer-name))
        output-file))))

(defun shell-command-on-region-to-string (start end command)
  (save-window-excursion
    (with-output-to-string
      (shell-command-on-region start end command standard-output))))

;;;###autoload
(defun markdown-copy-html ()
  "process file with multimarkdown and save it accordingly"
  (interactive)
  (save-window-excursion
    (flet ((markdown-output-standalone-p () t))
      (markdown))
    (with-current-buffer markdown-output-buffer-name
      (kill-ring-save (point-min) (point-max)))))

;;;###autoload
(defun markdown-copy-rtf ()
  "render markdown and copy as RTF"
  (interactive)
  (save-window-excursion
    (flet ((markdown-output-standalone-p () t))
      (let ((markdown-command markdown-rtf-command))
        (message (prin1-to-string (markdown-output-standalone-p)))
        (markdown)
        (with-current-buffer markdown-output-buffer-name
          (shell-command-on-region
           (point-min)
           (point-max)
           markdown-copy-command))))))

;;;###autoload
(defun markdown-copy-paste-html ()
  "process file with multimarkdown, copy it to the clipboard, and
  paste in safari's selected textarea"
  (interactive)
  (markdown-copy-html)
  (do-applescript
   (concat
    (let ((metafn (concat (buffer-file-name) ".meta")))
      (cond
       ((and (buffer-file-name) (file-exists-p metafn))
        (save-buffer)
        (with-temp-buffer
          (insert-file-contents-literally metafn)
          (goto-char (point-min))
          (do-applescript
           (concat
            "tell application \""
            (buffer-substring-no-properties (point-at-bol) (point-at-eol))
            "\" to activate"))))
       (t
        "
tell application \"System Events\" to keystroke tab using {command down}
delay 0.2"
        )))
    "
tell application \"System Events\" to keystroke \"a\" using {command down}
tell application \"System Events\" to keystroke \"v\" using {command down}")))


(provide 'markdown-mode+)

;;; markdown-mode+.el ends here
