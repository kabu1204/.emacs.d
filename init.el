(setq package-archives '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(light-blue))
 '(package-selected-packages
   '(ox-pandoc better-defaults inf-clojure clojure-mode-extra-font-locking cider))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "LightBlue" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Fira Code")))))

(package-initialize)

(package-refresh-contents)

(defvar my-packages '(better-defaults
                      projectile
                      clojure-mode
                      Cider))

(defun my-check-and-maybe-install (pkg)
  "Check and potentially install `PKG'."
  (when (not (package-installed-p pkg))
    (when (not (require pkg nil t))
      (package-install pkg))))

(defun my-packages-reset()
  "Reset package manifest to the defined set."
  (interactive)
  (package-refresh-contents)
  (mapc 'my-check-and-maybe-install my-useful-packages))


(setq mac-option-modifier 'meta)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "TERM=vt100 $SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(add-hook 'org-mode-hook
	  (lambda()
	    (setq truncate-lines nil))) 

;; export Org to PDF
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/texlive/2020/bin/x86_64-darwin/"))
(setq exec-path (append exec-path '("/usr/local/texlive/2020/bin/x86_64-darwin/")))
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f" "xelatex -interaction nonstopmode %f"))

;;line number
(global-linum-mode 1)
(setq linum-format "%d")

;;org indent mode
(setq org-startup-indented t)
