(setq package-archives '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "https://melpa.org/packages/")))
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
   '(htmlize ox-pandoc better-defaults inf-clojure clojure-mode-extra-font-locking cider))
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
                      Cider
		      company
		      company-racer
		      racer
		      flycheck
		      flycheck-rust
		      rust-mode))

;;manual pkg
(add-to-list 'load-path "~/.emacs.d/manual-pkg/rust-mode")
(autoload 'rust-mode "rust-mode" nil t)

;;htmlize
(require 'htmlize)

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
;;org src block native tab
(setq org-src-tab-acts-natively t)
;;org mode src highlight
(setq org-src-fontify-natively t)

;;;###autoload
(with-eval-after-load "org"
  (add-to-list 'org-src-lang-modes '("rust" . rust)))

;; Enable company globally for all mode
(global-company-mode)

;; Reduce the time after which the company auto completion popup opens
(setq company-idle-delay 0.2)

;; Reduce the number of characters before company kicks in
(setq company-minimum-prefix-length 1)
;; Set path to racer binary
(setq racer-cmd "/Users/ycy/.cargo/bin/racer")

;; Set rust-src path
(setq racer-rust-src-path "/Users/ycy/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/library")

;; Load rust-mode when you open `.rs` files
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
;; rust racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

;; Setting up configurations when you load rust-mode
(add-hook 'rust-mode-hook

     '(lambda ()
     ;; Enable racer
     (racer-mode)

     ;; Hook in racer with eldoc to provide documentation
     (eldoc-mode)

     ;; Use flycheck-rust in rust-mode
     (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

     ;; Use company-racer in rust mode
     (set (make-local-variable 'company-backends) '(company-racer))

     ;; Key binding to jump to method definition
     (local-set-key (kbd "M-.") #'racer-find-definition)

     ;; Key binding to auto complete and indent
     (local-set-key (kbd "TAB") #'racer-complete-or-indent)))
