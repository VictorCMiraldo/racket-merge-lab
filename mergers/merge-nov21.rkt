#lang racket

(require racket/set)
(require "../hdiff/base.rkt")

(provide (all-defined-out))

(define m-del (make-hash))
(define m-ins (make-hash))

(define s-protected (mutable-set))

(define (update-protected-set)
  (hash-for-each m-del (lambda (k term)
    (patch-map-tag 'var (lambda (v) (set-add! s-protected (var-get v))) term))))

(define (diff3 oa ob)
  (let ([r (patch-make oa ob 'disagreement)])
       (hash-clear! m-del)
       (hash-clear! m-ins)
       (patch-map-tag 'disagreement (curry reconcile 'phase1) r)
       (update-protected-set)
       (patch-map-tag 'disagreement (curry reconcile 'phase2) r)
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
             [else 'rest])
)) 


(define (refine-ins var)
  (hash-ref! m-ins (var-get var) `(var ,var)))

(define (refine-if-not-protected var)
  (cond [(not (set-member? s-protected (var-get var)))
           (refine-ins var)]
        [else var]
))

(define (inst-cpy-perm phase cp other)
  (cond [(eq? phase 'phase1)
           (hash-set! m-del (var-get (chg-get-del cp)) (patch-get-del other))
           (hash-set! m-ins (var-get (chg-get-del cp)) 
              (patch-map-tag 'var refine-ins (patch-get-ins other)))]
        [(eq? phase 'phase2)
           (list 'chg 
                 (patch-get-del other)
                 (refine-if-not-protected (chg-get-ins cp)))]
  )
)
  
