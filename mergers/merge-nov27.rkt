#lang racket

(require racket/set)
(require (rename-in "../hdiff/base.rkt"
                    (holes-match        old-holes-match)
                    (hash-add-contract  old-hash-add-contract)))

(provide (all-defined-out))

(define m-del (make-hash))
(define m-ins (make-hash))

(define (diff3 oa ob)
  (hash-clear! m-del)
  (hash-clear! m-ins)
  (hash-clear! m-match)
  (let [(phase1 (ast-zip-with<> oa ob reconcile))]
       (make-del-ins-maps)
       (ast-map-tag 'ref apply-refinements phase1))
)

(define (make-del-ins-maps)
  (hash-for-each m-match (lambda (k term)
    (hash-add-contract m-del k (patch-get-del term))
    (hash-add-contract m-ins k (patch-get-ins term)))))

(define (apply-refinements ref)
  (match (cdr ref)
    [(cons 'testeq   r) (ref-testequality r)]
    [(cons 'refine   r) (ref-refine r)]
    [(cons 'conflict r) (error "conflict")])
)

(define (ref-testequality ref2)
  (if (equal? (ref-refine (car ref2)) (ref-refine (cadr ref2)))
      (car ref2)
      (error "conflict!!!")))

(define (ref-refine ref2)
  (list 'chg (full-refine m-del (chg-get-del ref2))
             (full-refine m-ins (chg-get-ins ref2))))

(define (full-refine h term [vars (mutable-set)])
  (ast-map-tag 'var (lambda (v)
      (if (hash-has-key? h (var-get v))
          (hash-ref h (var-get v))
          v)) term)
;  (define aux (mutable-set))
;  (define term2 
;    (ast-map-tag 'var (lambda (v) 
;      (if (hash-has-key? h (var-get v))
;          (begin (set-add! aux (var-get v)) (hash-ref h (var-get v)))
;          v)) term)
;  )
;  (if (set=? aux vars) term2 (full-refine h term2 aux))
)
      
(define (reconcile ca cb)
 (cond [(and (chg? ca) (chg? cb)) (reconcile-chgchg ca cb)]
       [(chg? ca)                 (reconcile-app ca cb)]
       [(chg? cb)                 (reconcile-app cb ca)]
       [else                      'not-a-span]) ;; Precondition failure
)

(define (reconcile-chgchg ca cb)
;; Reconcile two changes
;;
  (cond [(cpy? ca) (reconcile-cpychg ca cb)]
        [(cpy? cb) (reconcile-cpychg cb ca)]
        [(cpy-or-perm? ca) (reconcile-app ca cb)]
        [(cpy-or-perm? cb) (reconcile-app cb ca)]
        [else `(ref testeq ,ca ,cb)])
)

(define (reconcile-cpychg cpy chg)
   (reconcile-app cpy chg)
   ;(hash-add-contract m-match (var-get (chg-get-del cpy)) chg)
   ;`(ref refine ,chg)
)
  
(define (reconcile-app-chgchg currdel chg)
  (cond [(cpy-or-perm? chg) 
            (hash-set! m-del (var-get (chg-get-del chg)) currdel)]
        [else (raise 'conflict)])
)

(define (reconcile-app chg term)
;; Reconcile a change over a spine.
;;
  (with-handlers ([(curry eq? 'conflict)
                  (lambda (_) `(ref conflict ,chg ,term))])
    (holes-match (chg-get-del chg) term reconcile-app-chgchg)
    `(ref refine ,chg)
))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; changelog:
;;
;; Instead of failing on contractions on the fly,
;; store them in a contractor and fail later.

(define (holes-match pat term [phi '()])
   (ast-zip-with (lambda (vx tx)
     (cond [(var? vx)         (hash-add-contract m-match (var-get vx) tx)]
           [(not (null? phi)) (phi vx tx)]
           [else (error (~a "pattern match fail: " vx " " tx))])) pat term)
   (void))

(define (contr1 v)
  (list 'ccc v))

(define (contr? l)
  (and (pair? l) (eq? (car l) 'ccc)))

(define (contr-+ ctr el)
  (if (not (member el ctr))
      (append (list 'ccc el) (cdr ctr))
      ctr))

(define (hash-add-contract h k v)
  (if (hash-has-key? h k)
      (hash-set! h k (contr-+ (hash-ref h k) v))
      (hash-set! h k (contr1 v))))



