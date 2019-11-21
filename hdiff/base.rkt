#lang racket

(provide (all-defined-out))

(define (var? node)
  (and (pair? node) (eq? 'var (car node))))

(define (var-get node)
  (car (cdr node)))

(define (chg? node)
  (and (pair? node) (eq? 'chg (car node))))

(define (chg-get-del chg)
  (car (cdr chg)))

(define (chg-get-ins chg)
  (car (cdr (cdr chg))))

(define (ast-zip-with f x y)
; Zips an ast with f
;   (X -> Y -> Z) -> T X -> T Y -> T Z
  (cond [(or (var? x) (var? y) (chg? x) (chg? y))
           (f x y)]
        [(and (not (pair? x)) (not (pair? y))) 
           (if (eq? x y) x (f x y))]
        [(and (pair? x) (pair? y) (eq? (car x) (car y)))
           (cons (car x) (map (curry ast-zip-with f) (cdr x) (cdr y)))]
        [else (f x y)]
  ))


(define (holes-match pat term)
   (ast-zip-with (lambda (vx tx)
     (cond [(var? vx) (hash-set! ht-matcher (var-get vx) tx)]
           [else (error "pattern match fail")])) pat term)
   (void))

(define (holes-inst pat)
  (cond [(var? pat)  (hash-ref ht-matcher (var-get pat))]
        [(pair? pat) (cons (car pat) (map holes-inst (cdr pat)))]
        [else        pat]
  ))

(define ht-matcher (make-hash))

(define (chg-apply chg term [clear-tbl #t])
  (cond (clear-tbl (hash-clear! ht-matcher)))
  (holes-match (chg-get-del chg) term)
  (holes-inst (chg-get-ins chg)))

(define (patch-make del ins [lbl 'chg])
; Makes a patch.
;   T X -> T Y -> T (T X * T Y)
  (ast-zip-with (lambda (x y) (list lbl x y)) del ins))

(define (patch-map-tag tag f tagged)
  (cond [(not (pair? tagged))   tagged]
        [(eq? (car tagged) tag) (f tagged)]
        [else                   (cons (car tagged) (map (curry patch-map-tag tag f) 
                                                        (cdr tagged)))]
  ))

(define (patch-get-del patch)
  (patch-map-tag 'chg chg-get-del patch))
(define (patch-get-ins patch)
  (patch-map-tag 'chg chg-get-ins patch))

(define (patch-apply patch term)
  (chg-apply (list 'chg (patch-get-del patch) (patch-get-ins patch)) term))

