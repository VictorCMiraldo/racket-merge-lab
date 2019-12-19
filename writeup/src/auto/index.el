(TeX-add-style-hook
 "index"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10")
   (LaTeX-add-bibliographies
    "references"))
 :latex)

