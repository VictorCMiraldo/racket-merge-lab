#lang racket

(require racket/set)
(require "../hdiff/base.rkt")

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
  (cond [(eq? (cadr ref) 'testeq) (ref-testequality (cddr ref))]
        [(eq? (cadr ref) 'refine) (ref-refine (caddr ref))]
        [(eq? (cadr ref) 'conflict) (error "conflict!")]
        [else (print "ah")])
)

(define (ref-testequality ref2)
  (if (equal? (ref-refine (car ref2)) (ref-refine (cadr ref2)))
      (car ref2)
      (error "conflict!")))

(define (ref-refine ref2)
  (list 'chg (full-refine m-del (chg-get-del ref2))
             (full-refine m-ins (chg-get-ins ref2))))

(define (full-refine h term [vars (mutable-set)])
  (define aux (mutable-set))
  (define term2 
    (ast-map-tag 'var (lambda (v) 
      (if (hash-has-key? h (var-get v))
          (begin (set-add! aux (var-get v)) (hash-ref h (var-get v)))
          v)) term)
  )
  (if (set=? aux vars) term2 (full-refine h term2 aux))
)
      
(define (reconcile ca cb)
 (cond [(and (chg? ca) (chg? cb)) (reconcile-chgchg ca cb)]
       [(chg? ca)                 (reconcile-app ca cb)]
       [(chg? cb)                 (reconcile-app cb ca)])
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
   (hash-add-contract m-match (var-get (chg-get-del cpy)) chg)
   `(ref refine ,chg)
)
  
(define rac-conf #f)
(define (reconcile-app-chgchg currdel chg)
  (cond [(cpy-or-perm? chg) 
            (hash-set! m-del (var-get (chg-get-del chg)) currdel)]
        [else (set! rac-conf #t)])
)

(define (reconcile-app chg term)
;; Reconcile a change over a spine.
;;
  (set! rac-conf #f)
  (holes-match (chg-get-del chg) term reconcile-app-chgchg)
  (cond [(eq? rac-conf #f) `(ref refine ,chg)]
        [(eq? rac-conf #t) `(ref conflict ,chg , term)])
)

