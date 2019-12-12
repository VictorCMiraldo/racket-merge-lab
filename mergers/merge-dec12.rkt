#lang racket

(require racket/set)
(require "../hdiff/base.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Unification Goodies ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(define (unify<> sigma x y) (unify x y sigma))

(define (unify x y [sigma (make-hash)])
  (match x
    [(list 'var vx) (unif-insert sigma x y)]
    [(cons cx px)  (match y
      [(list 'var vy) (unif-insert sigma y x)]
      [(cons cy py) (if (eq? cx cy)
                        (map (curry unify<> sigma) px py)
                        (raise 'unif:symbol-clash))])
        

    ])
   sigma
)

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
(define (anti-unif-fresh) 
  (define r auf-counter)
  (set! auf-counter (+ r 1))
  `(var ,(string->symbol (format "auf~a" r))))
  
(define (anti-unif x y)
  (define sx (make-hash))
  (define sy (make-hash))
  (define res 
    (ast-zip-with<> x y (lambda (dx dy)
      (define v (anti-unif-fresh))
      (hash-set! sx v dx)
      (hash-set! sy v dy)
      v)))
  (values res sx sy))

(define (diff3 sp sq)
  (define p0 (patch-get-del sp))
  (define p1 (patch-get-ins sp))
  (define q0 (patch-get-del sq))
  (define q1 (patch-get-ins sq))
  (let*-values ([(p dp ip) (anti-unif p0 p1)]
                [(q dq iq) (anti-unif q0 q1)])
    (define gamma (minimize (unify p q)))
    gamma
  )
)
