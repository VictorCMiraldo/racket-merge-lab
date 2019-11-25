#lang racket

(provide (all-defined-out))

(define (var? node)
  (and (pair? node) (eq? 'var (car node))))

(define (var-get node)
  (car (cdr node)))

(define (chg? node)
  (and (pair? node) (eq? 'chg (car node))))

(define (cpy? node)
  (and (chg? node)
    (let ([d (chg-get-del node)]
          [i (chg-get-ins node)])
         (and (var? d) (var? i) (eq? (var-get d) (var-get i))))))
 
(define (cpy-or-perm? node)
  (and (chg? node)
    (let ([d (chg-get-del node)]
          [i (chg-get-ins node)])
         (and (var? d) (var? i)))))
 

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

(define (ast-zip-with<> x y f) (ast-zip-with f x y))

(define (ast-map-tag tag f tagged)
  (cond [(not (pair? tagged))   tagged]
        [(eq? (car tagged) tag) (f tagged)]
        [else                   (cons (car tagged) (map (curry ast-map-tag tag f) 
                                                        (cdr tagged)))]
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Applying a deletion context to whatever term

(define (hash-add-contract h k v)
  (if (hash-has-key? h k)
      (when (not (eq? (hash-ref h k) v))
            (error (~a "contraction failure: " k " " v)))
      (hash-set! h k v)))

(define m-match (make-hash))
(define (holes-match pat term [phi '()])
   (ast-zip-with (lambda (vx tx)
     (cond [(var? vx)         (hash-add-contract m-match (var-get vx) tx)]
           [(not (null? phi)) (phi vx tx)]
           [else (error (~a "pattern match fail: " vx " " tx))])) pat term)
   (void))

(define (holes-inst pat)
  (cond [(var? pat)  (hash-ref m-match (var-get pat))]
        [(pair? pat) (cons (car pat) (map holes-inst (cdr pat)))]
        [else        pat]
  ))

(define (chg-apply chg term [clear-tbl #t])
  (cond (clear-tbl (hash-clear! m-match)))
  (holes-match (chg-get-del chg) term)
  (holes-inst (chg-get-ins chg)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Making of a Patch

(define (patch-make del ins [lbl 'chg])
; Makes a patch.
;   T X -> T Y -> T (T X * T Y)
  (ast-zip-with (lambda (x y) (list lbl x y)) del ins))

(define (patch-get-del patch)
  (ast-map-tag 'chg chg-get-del patch))

(define (patch-get-ins patch)
  (ast-map-tag 'chg chg-get-ins patch))

(define (patch-apply patch term)
  (chg-apply (list 'chg (patch-get-del patch) (patch-get-ins patch)) term))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variable Map of a patch

(define m-var (make-hash))
(define (patch-var-map patch)
  (hash-clear! m-var)
  (ast-map-tag 'var (lambda (x)
    (cond [(hash-has-key? m-var (var-get x))
             (hash-update! m-var (var-get x) incr)]
          [else 
             (hash-set! m-var (var-get x) 1)])
    ) patch)
)

(define (cpy?? chg)
  (and (cpy? chg) (eq? 1 (hash-ref m-var (var-get (chg-get-del chg)) (error "Did you run 'patch-var-map' before?")))))

(define (incr x) (+ 1 x))
;;
;;(define (categorize m chg)
;;  (let ([d (chg-get-del chg)]
;;        [i (chg-get-ins chg)])
;;       (cond [(and (var? d) (var? i))
;;                (let ([vd (var-get d)] [vi (var-get i)])
;;                     (if (eq? vd vi)
;;                         (if (eq? 2 (hash-ref! m vd)) 'cpy 'dup)
;;                         (if (and (eq? 2 (hash-ref! m vd)) (eq? 2 (hash-ref! m vd)))
;;                             'perm
;;                             'dup)))]
;;              [(j

                                       
              
               
                              
