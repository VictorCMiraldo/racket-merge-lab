#lang racket

(require racket/set)
(require racket/hash)
(require "../hdiff/base.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Unification Goodies ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(define (hd x) (match x 
  [(cons res _) res]
  [_            x]))

(define (tl x) (match x 
  [(cons _ res) res]
  [_            '()]))

(define (unify<> sigma x y) (unify x y sigma))

(define (unify x y [sigma (make-hash)])
  (match x
    [(list 'var vx) (unif-insert sigma x y)]
    [_ (match y
      [(list 'var vy) (unif-insert sigma y x)]
      [_  (if (equal? (hd x) (hd y))
              (map (curry unify<> sigma) (tl x) (tl y))
              (raise 'unif:symbol-clash))]) ])
   sigma
)

(define (unify* xs [sigma (make-hash)])
  (match xs
    [(cons x (cons y rs)) (unify* (cons y rs) (unify x y sigma))]
    [_                    sigma]))

(define (unif-insert sigma v y)
  (when (not (equal? y v))
        (hash-set! sigma v y)))

(define (subst-apply sigma t [s (mutable-set)])
  (define (go v) 
    (cond [(hash-has-key? sigma v) (set-add! s v) (hash-ref sigma v)]
          [else                    v]))
  (define t2 (ast-map-tag 'var go t))
  t2)

(define (minimize sigma [prev (mutable-set)])
  (define curr (mutable-set))
  (define res  (make-hash))
  (hash-for-each sigma (lambda (v t)
    (hash-set! res v (subst-apply sigma t curr))))
  (cond [(set-empty? curr)      res]
        [(set=?      curr prev) (raise 'unif:occurs-check)]
        [else                   (minimize res curr)])
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anti-Unification Goodies ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define auf-counter 1)
(define (anti-unif-fresh t) 
  (define r auf-counter)
  (set! auf-counter (+ r 1))
  `(var ,(string->symbol (format "~a~a" t r))))
  
(define (anti-unif x y [t 'auf])
  (define sx (make-hash))
  (define sy (make-hash))
  (define res 
    (ast-zip-with<> x y (lambda (dx dy)
      (define v (anti-unif-fresh t))
      (hash-set! sx v dx)
      (hash-set! sy v dy)
      v)))
  (values res sx sy))

(define (var-tag? v t)
  (match v
    [(list 'var n) (string-prefix? (symbol->string n) (symbol->string t))]
    [_             false]))

(define (mk-contr vs v) (match vs
  [(cons 'CONTR vs0) ('CONTR . v . vs)]
  [_                 (list 'CONTR v vs)]))
    
(define (contr-solve sigma)
  (hash-for-each sigma (lambda (v ts)
    (match ts
      [(cons 'CONTR ts0) (unify* ts0 sigma) (hash-set! sigma v (hd ts0))]
      [_                  void])))
  sigma
)

(define (simpl subst eqs)
  (hash-for-each eqs (lambda (vx tx)
    (cond [(hash-has-key? subst vx) (unify (hash-ref subst vx) tx subst)]
          [else                     (hash-set! subst vx tx)])
  ))
  (minimize subst) 
)

(define (diff3 sp sq)
  (define p0 (patch-get-del sp))
  (define p1 (patch-get-ins sp))
  (define q0 (patch-get-del sq))
  (define q1 (patch-get-ins sq))
  (let*-values ([(p dp ip) (anti-unif p0 p1 'vp)]
                [(q dq iq) (anti-unif q0 q1 'vq)])
    ;; discovery phase
    (define gamma (minimize (unify p q)))
    (hash-union! dp dq)
    (hash-union! ip iq) 

    (hash-for-each gamma (lambda (v t)
      ;; if t is a spine, we should "apply" (dp v |-> ip v) to t
      ;; if t is a variable; then we have the chg-chg scenario.
      (define chgA `(chg ,(subst-apply dp v) ,(subst-apply ip v)))
      (define chgB `(chg ,(subst-apply dp t) ,(subst-apply ip t)))
      (unify (subst-apply dp v) t ip)
    )) 
    (define dels (simpl (minimize dp) gamma)) 
    (define inss (minimize ip))
    (ast-map-tag<> 'var p (lambda (v)
      `(chg ,(subst-apply dels v) ,(subst-apply inss v))))
      

;;    (values p gamma (simpl (minimize dp) gamma) (minimize ip))
))



(define pa '(bin (chg (var 0) (var 1)) (chg (var 1) (var 0))))
(define pb '(bin (chg a b)             (chg (var 3) (var 3))))

(define qa '(chg (var 5) (bin (var 5) (var 5))))

;; 
;;     (define gamma (minimize (unify p q)))
;;     (hash-union! dp dq)
;;     (hash-union! ip iq) 
;;     (define dels dp)
;;     (define inss ip)
;; 
;;     (hash-for-each gamma (lambda (v t)
;;       (define st (minimize (unify t (hash-ref dels v))))
;;       (hash-union! dels st #:combine/key (lambda (k v0 v1) (mk-contr v0 v1)))
;;       ))
;; 
;;     (set! dels (minimize (contr-solve dels)))
;; 
;;     (define gamma2 (make-hash))
;;     (hash-for-each gamma (lambda (v t)
;;         (hash-set! gamma2 v `(chg ,(subst-apply dels t) 
;;                                   ,(subst-apply inss t))))
;;       )
;; 
;;     (let*-values ([(R RP RQ) (anti-unif p q 'r)])
;;        (values R RP RQ gamma2 dels inss))
;; ))


;; '(bina
;;   (chg (var 7) (var 7))
;;   (binb
;;    (chg (var 0) (var 1))
;;    (chg (binb (var 1) leaf) (binb (bina a leaf) (binb (var 0) leaf)))))
