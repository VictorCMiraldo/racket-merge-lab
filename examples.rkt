#lang racket

(require "hdiff/base.rkt")
(require "mergers/merge-nov21.rkt")

;; Test Values

(define del0
  '(bin (var 0) (bin (var 1) leaf)))

(define ins0 
  '(bin (var 1) (bin (var 0) leaf)))

;; omg; the beauty of qausiquoting! *.*
(define chg0 `(chg ,del0 ,ins0))

(define p1 (patch-make del0 ins0))

(define q1 (patch-make
  '(bin a (var 2))
  '(bin b (var 2))))

(define p2 (patch-make
  '(bin (var 0) (bin c leaf))
  '(bin (var 0) (bin (var 0) leaf))))

(define q2 q1)

(define p4 (patch-make
  '(bin a (bin (var 4) (bin k (var 2))))
  '(bin (var 4) (var 2))))

(define q4 (patch-make
  '(bin (var 7) (bin (var 8) (bin (var 9) (var 0))))
  '(bin (var 7) (bin (var 8) (bin (var 9) (bin n (var 0)))))))

(define term0
  '(bin (bin A B) (bin C leaf)))

(define term1
  '(bin (tri X Y Z) (bin Z B)))


(define xd '(bin (var 8) (bin (var 9) (var 0))))
(define xi '(bin (var 8) (bin (var 9) (bin n (var 0)))))
(define y '(chg (bin (var 4) (bin k (var 2)))
                (var 2)))

