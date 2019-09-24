;; editor/god/autoload/god.el -*- lexical-binding: t; -*-

(defvar god-default-color (face-background 'cursor)
  "Default cursor and bar color.")

(defvar god-read-only-mode-color "Gray"
  "Cursor and bar color when `read-only-mode' is enabled.")

(defvar god-overwrite-mode-color "Yellow"
  "Cursor and bar color when `overwrite-mode' is enabled.")

(defvar god-fill-overflow-color "IndianRed"
  "Cursor and bar color when fill column width has been exceeded.")

;;;###autoload
(defvar god-default-exempt-major-modes
  '(Custom-mode
    Info-mode
    ag-mode
    calculator-mode
    calendar-mode
    cider-test-report-mode
    compilation-mode
    debugger-mode
    dired-mode
    edebug-mode
    ediff-mode
    eww-mode
    geben-breakpoint-list-mode
    git-commit-mode
    grep-mode
    ibuffer-mode
    magit-popup-mode
    org-agenda-mode
    pdf-outline-buffer-mode
    recentf-dialog-mode
    sldb-mode
    sly-db-mode
    vc-annotate-mode
    wdired-mode)
  "Major modes in which `god-local-mode' will not be enabled on
initialization.")

;;;###autoload
(defun god--configure-cursor-and-modeline ()
  "Configure cursor type, cursor color and doom-modeline bar color depending on mode."
  (let* ((is-fill-overflow (> (current-column) fill-column))
         (previous-cursor-color (face-background 'cursor))
         (previous-modeline-color (and (facep 'doom-modeline-bar)
                                       (face-background 'doom-modeline-bar)))
         (is-god-mode (and (boundp 'god-local-mode)
                           god-local-mode))
         (next-cursor-type
          (cond (buffer-read-only 'box)
                ((and overwrite-mode is-god-mode) 'hollow)
                ((or is-god-mode overwrite-mode) 'box)
                (t 'bar)))
         (next-cursor-and-modeline-color
          (cond (buffer-read-only god-read-only-mode-color)
                (is-fill-overflow god-fill-overflow-color)
                (overwrite-mode god-overwrite-mode-color)
                (t god-default-color))))
    (setq cursor-type next-cursor-type)
    (unless (eq previous-cursor-color next-cursor-and-modeline-color)
      (set-cursor-color next-cursor-and-modeline-color))
    (when (and (facep 'doom-modeline-bar)
               (fboundp 'doom-modeline-refresh-bars)
               (not (eq previous-modeline-color next-cursor-and-modeline-color)))
      (set-face-attribute 'doom-modeline-bar nil :background next-cursor-and-modeline-color)
      (doom-modeline-refresh-bars))))

;;;###autoload
(defun god--toggle-on-overwrite ()
  (if (bound-and-true-p overwrite-mode)
      (god-local-mode-pause)
    (god-local-mode-resume)))
