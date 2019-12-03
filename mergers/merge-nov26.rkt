#lang racket

(require racket/set)
(require "../hdiff/base.rkt")

(provide (all-defined-out))

(define m-del (make-hash))
(define m-ins (make-hash))

(define (diff3 oa ob)
;; The algorithm proceeds in two phases. 
;; First we reconcile the own-variable map of
;; the anti-unification of oa and ob
;;
  (hash-clear! m-del)
  (hash-clear! m-ins)
  (hash-clear! m-match)
  (let [(phase1 (ast-zip-with<> oa ob reconcile))]
       (make-del-ins-maps) ;; the we split the maps ensuring
                           ;; all our decisions are consistent.
       ;; Finally, we perform either refinements or
       ;; equality checks on the places where phase1 has signalled.
       (ast-map-tag 'ref apply-refinements phase1))
)

(define (make-del-ins-maps)
;; Splits the m-match map into the deletion part and insertion part.
;; m-match :: Map Int (Holes Int , Holes Int)
;;
  (hash-for-each m-match (lambda (k term)
    (hash-add-contract m-del k (patch-get-del term))
    (hash-add-contract m-ins k (patch-get-ins term)))))

(define (apply-refinements ref)
  (cond [(eq? (cadr ref) 'testeq) (ref-testequality (cddr ref))]
        [(eq? (cadr ref) 'refine) (ref-refine (caddr ref))]
        [(eq? (cadr ref) 'conflict) (error "conflict!")])
)

(define (ref-testequality ref2)
; ref2 :: (Chg , Chg)
;
; Ensures the changes are equal.
  (if (equal? (ref-refine (car ref2)) (ref-refine (cadr ref2)))
      (car ref2)
      (error "conflict!!!")))

(define (ref-refine chg)
; chg :: Chg
  (list 'chg (full-refine m-del (chg-get-del chg))
             (full-refine m-ins (chg-get-ins chg))))

(define (full-refine h term [vars (mutable-set)])
; Given a term and a hash map 'h'; substitute the variables
; of the term until a fixpoint is reached.
; Pardon the ugly implementation...
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
; ca :: Patch
; cb :: Patch
 (cond [(and (chg? ca) (chg? cb)) (reconcile-chgchg ca cb)]
       [(chg? ca)                 (reconcile-app ca cb)]
       [(chg? cb)                 (reconcile-app cb ca)]
       [else                      'not-a-span]) ;; Precondition failure
)

(define (reconcile-chgchg ca cb)
;; Reconcile two changes at the same point.
;;
;; If either is a copy or a permutation we are fine,
;; otherwise, we can only accept this if they are the same change.
;;
;; ca , cb :: Chg
  (cond [(cpy-or-perm? ca) (reconcile-app ca cb)]
        [(cpy-or-perm? cb) (reconcile-app cb ca)]
        [else `(ref testeq ,ca ,cb)])
)

(define (reconcile-app-chgchg currdel chg)
; Tries to salvage the match of a deletion context ove
; a change. As usual, if this change is just a copy or permutation
; we record our instantiation and go on, otherwise we raise
; a conflict.
  (cond [(cpy-or-perm? chg) 
            (hash-set! m-del (var-get (chg-get-del chg)) currdel)]
        [else (raise 'conflict)])
)

(define (reconcile-app chg spine)
;; Reconcile a change over a spine; The idea is that
;; we will try to match the deletion context (d) of the
;; change against the spine. If this fails because (d)
;; requires some specific shape but the spine contains a change
;; at that point, we call 'reconcile-app-chgchg'.
;;
  (with-handlers ([(curry eq? 'conflict)
                  (lambda (_) `(ref conflict ,chg ,spine))])
    (holes-match (chg-get-del chg) spine reconcile-app-chgchg)
    ;; When this is all said and done, we issue a 'refine
    ;; tag for the next pass.
    `(ref refine ,chg)
))

