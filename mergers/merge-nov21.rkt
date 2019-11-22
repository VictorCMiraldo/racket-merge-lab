#lang racket

(require racket/set)
(require "../hdiff/base.rkt")

(provide (all-defined-out))

(define m-del (make-hash))
(define m-ins (make-hash))
(define m-unif (make-hash))


(define s-enabled (mutable-set))

(define (update-enabled-set)
;; The 'protected' set is a set of metavariables that need not be
;; instantiated in the insertion contexts because they are "shadowed"
;; by a variable in a deletion context. Example:
;;
;; > ca = '(chg (data X (var 1)) (var 1))  
;; >
;; > cb = '(chg (var 3) (var 3))
;;
;; Here, we will call (inst-cpy-perm phase cb ca), which will trigger
;; (var 3) to be instantiated to '(data x (var 1)) in m-del; this means
;; that the occurences of (var 1) that appear unbound in the insertion contexts
;; are 'protected of errors' because (var 1) has a definition point.
  (hash-for-each m-del (lambda (k term)
    (ast-map-tag 'var (lambda (v) (set-add! s-enabled (var-get v))) term))))

(define (diff3 oa ob)
  (let ([r (patch-make oa ob 'disagreement)])
       (hash-clear! m-del)
       (hash-clear! m-ins)
       (hash-clear! m-unif)
       (ast-map-tag 'disagreement (curry reconcile 'phase1) r)
       (update-enabled-set)
       (ast-map-tag 'disagreement (curry reconcile 'phase2) r)
))

(define (cpy-or-perm? ca)
  (and (chg? ca) (var? (chg-get-del ca)) (var? (chg-get-ins ca)))) 

(define (reconcile phase dis)
  (let ([ca (car (cdr dis))]
        [cb (car (cdr (cdr dis)))])
       (cond [(cpy-or-perm? ca)
                 (inst-cpy-perm phase ca cb)]
             [(cpy-or-perm? cb)
                 (inst-cpy-perm phase cb ca)]
             [(and (chg? ca) (not (chg? cb)))
                 (unif-and-apply phase ca cb)]
             [(and (chg? cb) (not (chg? ca)))
                 (unif-and-apply phase ca cb)]
             [else 'rest])
)) 

(define (refine-ins var)
  (hash-ref! m-ins (var-get var) var))

(define (refine-if-not-protected var)
  (cond [(not (set-member? s-enabled (var-get var)))
           (refine-ins var)]
        [else var]
))

(define (unif del patch)
  (ast-zip-with<> del patch
    (lambda (dv pt) (
      cond [(var? dv)         (void)]
           [(cpy-or-perm? pt) 
              (let [(v (var-get (chg-get-del pt)))]
                   (if (and (hash-has-key? m-unif v) (not (eq? dv (hash-ref! m-unif v))))
                       (error "unif: contraction failure")
                       (hash-set! m-unif v dv)))]
           [else (error "unif: can't apply!")]
    ))
)) 

(define (unif-and-apply phase chg rst)
;; here chg is '(chg del ins) and rst is
;; a spine. 
;;
;; We must try to apply chg to rst; but this is not a trivial task
;; since rst might very well be more general than chg.

  
  ;; (when (eq? phase 'phase1) (unif (chg-get-del chg) rst))
  (when (eq? phase 'phase2) (chg-apply chg rst))
)

(define (thin rst)
  (ast-map-tag 'chg (lambda (c) (if (eq? (chg-get-del c) (chg-get-ins c))
                                      (chg-get-del c)
                                      c))
    (ast-map-tag 'var (lambda (v) (hash-ref m-unif (var-get v) v)) rst))
)

(define (inst-cpy-perm phase cp other)
;; cp is of the form (var x |-> var y)
  (cond [(eq? phase 'phase1)
           (hash-set! m-del (var-get (chg-get-del cp)) (patch-get-del other))
           (hash-set! m-ins (var-get (chg-get-del cp)) 
              (ast-map-tag 'var refine-ins (patch-get-ins other)))]
        [(eq? phase 'phase2)
           (list 'chg 
                 (patch-get-del other)
                 ;; TODO: don't assume cp is (var x |-> var y)
                 ;;       instead, assume cp is (var x |-> TY) and ensure
                 ;;       that instantiating TY leaves only enabled variables behind.
                 ;; TODO2: assume that cp is (TX |-> TY), and now, perform unification
                 ;;        with 'other'. This would make a more uniform merging approach
                 ;;        It seems like if we keep careful track of the enabled set
                 ;;        we might be able to make this work.
                 (refine-if-not-protected (chg-get-ins cp)))] 
  )
)
  
