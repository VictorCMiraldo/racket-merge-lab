#lang racket

(require racket/set)
(require racket/hash)
(require "../hdiff/base.rkt")
(provide (all-defined-out))

(define (getAnn x)
  (match x [(cons 'ann (cons an _)) an]))

(define (merkle tree) 
  (match tree
    [base (list 'ann (hash base) base)]
    [(cons constr args) 
       (define args' (map (synth f) args))
       (define anns  (map getAnn args'))
       
      
