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
       (ast-map-tag 'chg apply-refinements phase1))
)

(define (make-del-ins-maps)
  (hash-for-each m-match (lambda (k term)
    (hash-add-contract m-del k (patch-get-del term))
    (hash-add-contract m-ins k (patch-get-ins term)))))

(define (apply-refinements chg)
  (list 'chg (full-refine m-del (chg-get-del chg))
             (full-refine m-ins (chg-get-ins chg))))

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
        [else (error (~a "conflict? " ca " ; " cb))])
)

(define (reconcile-cpychg cpy chg)
   (hash-add-contract m-match (var-get (chg-get-del cpy)) chg)
   chg
)
  
;; unused!
(define m-protect (make-hash)
;; The m-protect set lets us know which variables are protected.
;; That is, when applying a change to another change,
;; if we see a situation like: (holes-match pd '(chg qd qi))
;; this means that we are currently attempting to "delete" some information
;; that the patch q might use. If the patch q just copies it, great,
;; but if we ever try to return a variable from the protected set, 
;; we have a conflict in our hands.
)

;; should I register in m-del or m-protect?
(define (register-eq delA delB)
  (cond [(var? delB) (hash-set! m-del (var-get delB) delA)]
        [else        (error "I thought delB has to always be a variable")])
)

(define (reconcile-app-chgchg currdel chg)
;; When applying a change over a patch, we might
;; have to apply a deletion context to a change.
;; Naturally, the chg and (chg-get-del term) must be compatible
;; (precondition: patches make a span).
  (holes-match currdel (chg-get-del chg) register-eq))

(define (reconcile-app chg term)
;; Reconcile a change over a spine.
;;
  (holes-match (chg-get-del chg) term reconcile-app-chgchg)
  `(chg ,(chg-get-del chg) ,(chg-get-ins chg))
)

