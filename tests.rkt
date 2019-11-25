#lang racket

(require "hdiff/base.rkt")
(require "mergers/merge-nov25.rkt")

(define (runtc tc) 
  (let ([pa (cadr tc)] 
        [pb (caddr tc)] 
        [o  (cadddr tc)] 
        [r (cadr (cdddr tc))])

   (with-handlers ([exn:fail? (lambda (ex) (begin (print ex) (if (eq? r 'conflict) 'success 'failed)))])
      (let ([m (diff3 pa pb)])
        (cond [(eq? r 'conflict) 'wow]
              [else (if (equal? (patch-apply m o) r) 'success 'failed)]))
   )) 
)
  

(define dela-1nn
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-1nn
  '(bina (var 3) (binb (var 1)  (binb  (bina  c  leaf) (var 0)))))
(define pa-1nn
  (patch-make dela-1nn insa-1nn ))
(define delb-1nn
  '(bina (var 7) (binb (bina b leaf)  (var 5))))
(define insb-1nn
  '(bina (var 7) (binb (bina B leaf)  (var 5))))
(define pb-1nn
  (patch-make delb-1nn insb-1nn ))
(define o1nn
  '(bina a (binb (bina b leaf ) (binb (bina d leaf ) leaf)) ))
(define r1nn
  '(bina a (binb (bina B leaf ) (binb (bina c leaf ) (binb (bina d leaf ) leaf))) ))
(define tc1nn (list 'tc pa-1nn pb-1nn o1nn r1nn))
(define dela-1ps
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-1ps
  '(bina (var 3) (binb (var 1)  (binb  (bina  c  leaf) (var 0)))))
(define pa-1ps
  (patch-make dela-1ps insa-1ps ))
(define delb-1ps
  '(bina (var 7) (binb (bina b leaf)  (var 5))))
(define insb-1ps
  '(bina (var 7) (binb (bina B leaf)  (var 5))))
(define pb-1ps
  (patch-make delb-1ps insb-1ps ))
(define o1ps
  '(bina a (binb (bina b leaf ) (binb (bina d leaf ) leaf)) ))
(define r1ps
  '(bina a (binb (bina B leaf ) (binb (bina c leaf ) (binb (bina d leaf ) leaf))) ))
(define tc1ps (list 'tc pa-1ps pb-1ps o1ps r1ps))
(define dela-1pp
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-1pp
  '(bina (var 3) (binb (var 1)  (binb  (bina  c  leaf) (var 0)))))
(define pa-1pp
  (patch-make dela-1pp insa-1pp ))
(define delb-1pp
  '(bina (var 7) (binb (bina b leaf)  (var 5))))
(define insb-1pp
  '(bina (var 7) (binb (bina B leaf)  (var 5))))
(define pb-1pp
  (patch-make delb-1pp insb-1pp ))
(define o1pp
  '(bina a (binb (bina b leaf ) (binb (bina d leaf ) leaf)) ))
(define r1pp
  '(bina a (binb (bina B leaf ) (binb (bina c leaf ) (binb (bina d leaf ) leaf))) ))
(define tc1pp (list 'tc pa-1pp pb-1pp o1pp r1pp))
(define dela-2nn
  '(bina b (binb (var 3)  (binb  (bina  D  leaf) leaf))))
(define insa-2nn
  '(var 3))
(define pa-2nn
  (patch-make dela-2nn insa-2nn ))
(define delb-2nn
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   3   leaf)  leaf))  (var 5)))  (var 7))))
(define insb-2nn
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   4   leaf)  leaf))  (binb  (bina  u  (var 5))   leaf)))  (var 7))))
(define pb-2nn
  (patch-make delb-2nn insb-2nn ))
(define o2nn
  '(bina b (binb (bina b (binb (bina u (binb (bina 3 leaf ) leaf) ) (binb (bina DD leaf ) leaf)) ) (binb (bina D leaf ) leaf)) ))
(define r2nn
  '(bina b (binb (bina u (binb (bina 4 leaf ) leaf) ) (binb (bina u (binb (bina DD leaf ) leaf) ) leaf)) ))
(define tc2nn (list 'tc pa-2nn pb-2nn o2nn r2nn))
(define dela-2ps
  '(bina b (binb (var 3)  (binb  (bina  D  leaf) leaf))))
(define insa-2ps
  '(var 3))
(define pa-2ps
  (patch-make dela-2ps insa-2ps ))
(define delb-2ps
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   3   leaf)  leaf))  (var 5)))  (var 7))))
(define insb-2ps
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   4   leaf)  leaf))  (binb  (bina  u  (var 5))   leaf)))  (var 7))))
(define pb-2ps
  (patch-make delb-2ps insb-2ps ))
(define o2ps
  '(bina b (binb (bina b (binb (bina u (binb (bina 3 leaf ) leaf) ) (binb (bina DD leaf ) leaf)) ) (binb (bina D leaf ) leaf)) ))
(define r2ps
  '(bina b (binb (bina u (binb (bina 4 leaf ) leaf) ) (binb (bina u (binb (bina DD leaf ) leaf) ) leaf)) ))
(define tc2ps (list 'tc pa-2ps pb-2ps o2ps r2ps))
(define dela-2pp
  '(bina b (binb (var 3)  (binb  (bina  D  leaf) leaf))))
(define insa-2pp
  '(var 3))
(define pa-2pp
  (patch-make dela-2pp insa-2pp ))
(define delb-2pp
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   3   leaf)  leaf))  (var 5)))  (var 7))))
(define insb-2pp
  '(bina (var 9) (binb (bina (var 10) (binb (bina   (var 11)   (binb   (bina   4   leaf)  leaf))  (binb  (bina  u  (var 5))   leaf)))  (var 7))))
(define pb-2pp
  (patch-make delb-2pp insb-2pp ))
(define o2pp
  '(bina b (binb (bina b (binb (bina u (binb (bina 3 leaf ) leaf) ) (binb (bina DD leaf ) leaf)) ) (binb (bina D leaf ) leaf)) ))
(define r2pp
  '(bina b (binb (bina u (binb (bina 4 leaf ) leaf) ) (binb (bina u (binb (bina DD leaf ) leaf) ) leaf)) ))
(define tc2pp (list 'tc pa-2pp pb-2pp o2pp r2pp))
(define dela-3nn
  '(bina x (var 3)))
(define insa-3nn
  '(bina X (var 3)))
(define pa-3nn
  (patch-make dela-3nn insa-3nn ))
(define delb-3nn
  '(bina (var 5) (binb (bina y leaf)  (binb  (bina  z  leaf) leaf))))
(define insb-3nn
  '(bina (var 5) (binb (bina Y leaf)  leaf)))
(define pb-3nn
  (patch-make delb-3nn insb-3nn ))
(define o3nn
  '(bina x (binb (bina y leaf ) (binb (bina z leaf ) leaf)) ))
(define r3nn
  '(bina X (binb (bina Y leaf ) leaf) ))
(define tc3nn (list 'tc pa-3nn pb-3nn o3nn r3nn))
(define dela-3ps
  '(bina x (var 3)))
(define insa-3ps
  '(bina X (var 3)))
(define pa-3ps
  (patch-make dela-3ps insa-3ps ))
(define delb-3ps
  '(bina (var 5) (binb (bina y leaf)  (binb  (bina  z  leaf) leaf))))
(define insb-3ps
  '(bina (var 5) (binb (bina Y leaf)  leaf)))
(define pb-3ps
  (patch-make delb-3ps insb-3ps ))
(define o3ps
  '(bina x (binb (bina y leaf ) (binb (bina z leaf ) leaf)) ))
(define r3ps
  '(bina X (binb (bina Y leaf ) leaf) ))
(define tc3ps (list 'tc pa-3ps pb-3ps o3ps r3ps))
(define dela-3pp
  '(bina x (var 3)))
(define insa-3pp
  '(bina X (var 3)))
(define pa-3pp
  (patch-make dela-3pp insa-3pp ))
(define delb-3pp
  '(bina (var 5) (binb (bina y leaf)  (binb  (bina  z  leaf) leaf))))
(define insb-3pp
  '(bina (var 5) (binb (bina Y leaf)  leaf)))
(define pb-3pp
  (patch-make delb-3pp insb-3pp ))
(define o3pp
  '(bina x (binb (bina y leaf ) (binb (bina z leaf ) leaf)) ))
(define r3pp
  '(bina X (binb (bina Y leaf ) leaf) ))
(define tc3pp (list 'tc pa-3pp pb-3pp o3pp r3pp))
(define dela-4nn
  '(bina x leaf))
(define insa-4nn
  '(bina y leaf))
(define pa-4nn
  (patch-make dela-4nn insa-4nn ))
(define delb-4nn
  '(bina x leaf))
(define insb-4nn
  '(bina y leaf))
(define pb-4nn
  (patch-make delb-4nn insb-4nn ))
(define o4nn
  '(bina x leaf ))
(define r4nn
  '(bina y leaf ))
(define tc4nn (list 'tc pa-4nn pb-4nn o4nn r4nn))
(define dela-4ps
  '(bina x leaf))
(define insa-4ps
  '(bina y leaf))
(define pa-4ps
  (patch-make dela-4ps insa-4ps ))
(define delb-4ps
  '(bina x leaf))
(define insb-4ps
  '(bina y leaf))
(define pb-4ps
  (patch-make delb-4ps insb-4ps ))
(define o4ps
  '(bina x leaf ))
(define r4ps
  '(bina y leaf ))
(define tc4ps (list 'tc pa-4ps pb-4ps o4ps r4ps))
(define dela-4pp
  '(bina x leaf))
(define insa-4pp
  '(bina y leaf))
(define pa-4pp
  (patch-make dela-4pp insa-4pp ))
(define delb-4pp
  '(bina x leaf))
(define insb-4pp
  '(bina y leaf))
(define pb-4pp
  (patch-make delb-4pp insb-4pp ))
(define o4pp
  '(bina x leaf ))
(define r4pp
  '(bina y leaf ))
(define tc4pp (list 'tc pa-4pp pb-4pp o4pp r4pp))
(define dela-5nn
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-5nn
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-5nn
  (patch-make dela-5nn insa-5nn ))
(define delb-5nn
  '(bina (var 8) (var 7)))
(define insb-5nn
  '(bina (var 8) (binb (bina y (var 7))  (var 7))))
(define pb-5nn
  (patch-make delb-5nn insb-5nn ))
(define o5nn
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r5nn
  '(bina x (binb (bina y (binb (bina k leaf ) (binb (bina u leaf ) leaf)) ) (binb (bina k leaf ) (binb (bina u leaf ) leaf))) ))
(define tc5nn (list 'tc pa-5nn pb-5nn o5nn r5nn))
(define dela-5ps
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-5ps
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-5ps
  (patch-make dela-5ps insa-5ps ))
(define delb-5ps
  '(bina (var 8) (var 7)))
(define insb-5ps
  '(bina (var 8) (binb (bina y (var 7))  (var 7))))
(define pb-5ps
  (patch-make delb-5ps insb-5ps ))
(define o5ps
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r5ps
  '(bina x (binb (bina y (binb (bina k leaf ) (binb (bina u leaf ) leaf)) ) (binb (bina k leaf ) (binb (bina u leaf ) leaf))) ))
(define tc5ps (list 'tc pa-5ps pb-5ps o5ps r5ps))
(define dela-5pp
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-5pp
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-5pp
  (patch-make dela-5pp insa-5pp ))
(define delb-5pp
  '(bina (var 8) (binb (bina u leaf)  (binb  (bina  k  leaf) leaf))))
(define insb-5pp
  '(bina (var 8) (binb (bina y (binb (bina   u   leaf)  (binb  (bina  k  leaf)   leaf)))  (binb  (bina  u  leaf) (binb (bina   k   leaf)  leaf)))))
(define pb-5pp
  (patch-make delb-5pp insb-5pp ))
(define o5pp
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r5pp
  '(bina x (binb (bina u leaf ) (binb (bina y (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ) (binb (bina k leaf ) leaf))) ))
(define tc5pp (list 'tc pa-5pp pb-5pp o5pp r5pp))
(define dela-6nn
  '(bina (var 1) (binb (var 0)  (binb  (bina  k  leaf) leaf))))
(define insa-6nn
  '(bina (var 1) (binb (var 0)  leaf)))
(define pa-6nn
  (patch-make dela-6nn insa-6nn ))
(define delb-6nn
  '(bina (var 7) (var 6)))
(define insb-6nn
  '(bina (var 7) (binb (bina y (var 6))  (var 6))))
(define pb-6nn
  (patch-make delb-6nn insb-6nn ))
(define o6nn
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r6nn
  '(bina x (binb (bina y (binb (bina u leaf ) leaf) ) (binb (bina u leaf ) leaf)) ))
(define tc6nn (list 'tc pa-6nn pb-6nn o6nn r6nn))
(define dela-6ps
  '(bina (var 1) (binb (var 0)  (binb  (bina  k  leaf) leaf))))
(define insa-6ps
  '(bina (var 1) (binb (var 0)  leaf)))
(define pa-6ps
  (patch-make dela-6ps insa-6ps ))
(define delb-6ps
  '(bina (var 7) (var 6)))
(define insb-6ps
  '(bina (var 7) (binb (bina y (var 6))  (var 6))))
(define pb-6ps
  (patch-make delb-6ps insb-6ps ))
(define o6ps
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r6ps
  '(bina x (binb (bina y (binb (bina u leaf ) leaf) ) (binb (bina u leaf ) leaf)) ))
(define tc6ps (list 'tc pa-6ps pb-6ps o6ps r6ps))
(define dela-6pp
  '(bina (var 1) (binb (var 0)  (binb  (bina  k  leaf) leaf))))
(define insa-6pp
  '(bina (var 1) (binb (var 0)  leaf)))
(define pa-6pp
  (patch-make dela-6pp insa-6pp ))
(define delb-6pp
  '(bina (var 7) (binb (bina u leaf)  (binb  (bina  k  leaf) leaf))))
(define insb-6pp
  '(bina (var 7) (binb (bina y (binb (bina   u   leaf)  (binb  (bina  k  leaf)   leaf)))  (binb  (bina  u  leaf) (binb (bina   k   leaf)  leaf)))))
(define pb-6pp
  (patch-make delb-6pp insb-6pp ))
(define o6pp
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r6pp 'conflict)
(define tc6pp (list 'tc pa-6pp pb-6pp o6pp r6pp))
(define dela-7nn
  '(bina (var 5) (binb (bina a leaf)  (binb  (var 4) (binb (bina   k   leaf)  (var 2))))))
(define insa-7nn
  '(bina (var 5) (binb (var 4)  (var 2))))
(define pa-7nn
  (patch-make dela-7nn insa-7nn ))
(define delb-7nn
  '(bina x (binb (var 11)  (binb  (var 13) (binb (var 12)  (var 9))))))
(define insb-7nn
  '(bina y (binb (var 11)  (binb  (var 13) (binb (var 12)  (binb  (bina  new  leaf)   (var 9)))))))
(define pb-7nn
  (patch-make delb-7nn insb-7nn ))
(define o7nn
  '(bina x (binb (bina a leaf ) (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina k leaf ) (binb (bina l leaf ) leaf)))) ))
(define r7nn
  '(bina y (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina new leaf ) (binb (bina l leaf ) leaf))) ))
(define tc7nn (list 'tc pa-7nn pb-7nn o7nn r7nn))
(define dela-7ps
  '(bina (var 5) (binb (bina a leaf)  (binb  (var 4) (binb (bina   k   leaf)  (var 2))))))
(define insa-7ps
  '(bina (var 5) (binb (var 4)  (var 2))))
(define pa-7ps
  (patch-make dela-7ps insa-7ps ))
(define delb-7ps
  '(bina x (binb (var 11)  (binb  (var 13) (binb (var 12)  (var 9))))))
(define insb-7ps
  '(bina y (binb (var 11)  (binb  (var 13) (binb (var 12)  (binb  (bina  new  leaf)   (var 9)))))))
(define pb-7ps
  (patch-make delb-7ps insb-7ps ))
(define o7ps
  '(bina x (binb (bina a leaf ) (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina k leaf ) (binb (bina l leaf ) leaf)))) ))
(define r7ps
  '(bina y (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina new leaf ) (binb (bina l leaf ) leaf))) ))
(define tc7ps (list 'tc pa-7ps pb-7ps o7ps r7ps))
(define dela-7pp
  '(bina (var 5) (binb (bina a leaf)  (binb  (var 4) (binb (bina   k   leaf)  (var 2))))))
(define insa-7pp
  '(bina (var 5) (binb (var 4)  (var 2))))
(define pa-7pp
  (patch-make dela-7pp insa-7pp ))
(define delb-7pp
  '(bina x (binb (var 11)  (binb  (var 13) (binb (var 12)  (var 9))))))
(define insb-7pp
  '(bina y (binb (var 11)  (binb  (var 13) (binb (var 12)  (binb  (bina  new  leaf)   (var 9)))))))
(define pb-7pp
  (patch-make delb-7pp insb-7pp ))
(define o7pp
  '(bina x (binb (bina a leaf ) (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina k leaf ) (binb (bina l leaf ) leaf)))) ))
(define r7pp
  '(bina y (binb (bina u (binb (bina b leaf ) leaf) ) (binb (bina new leaf ) (binb (bina l leaf ) leaf))) ))
(define tc7pp (list 'tc pa-7pp pb-7pp o7pp r7pp))
(define dela-8nn
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-8nn
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-8nn
  (patch-make dela-8nn insa-8nn ))
(define delb-8nn
  '(bina (var 7) (binb (var 5)  (var 4))))
(define insb-8nn
  '(bina (var 7) (binb (var 5)  (binb  (bina  a  leaf) (var 4)))))
(define pb-8nn
  (patch-make delb-8nn insb-8nn ))
(define o8nn
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r8nn
  '(bina x (binb (bina k leaf ) (binb (bina a leaf ) (binb (bina u leaf ) leaf))) ))
(define tc8nn (list 'tc pa-8nn pb-8nn o8nn r8nn))
(define dela-8ps
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-8ps
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-8ps
  (patch-make dela-8ps insa-8ps ))
(define delb-8ps
  '(bina (var 7) (binb (var 5)  (var 4))))
(define insb-8ps
  '(bina (var 7) (binb (var 5)  (binb  (bina  a  leaf) (var 4)))))
(define pb-8ps
  (patch-make delb-8ps insb-8ps ))
(define o8ps
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r8ps
  '(bina x (binb (bina k leaf ) (binb (bina a leaf ) (binb (bina u leaf ) leaf))) ))
(define tc8ps (list 'tc pa-8ps pb-8ps o8ps r8ps))
(define dela-8pp
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-8pp
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-8pp
  (patch-make dela-8pp insa-8pp ))
(define delb-8pp
  '(bina (var 7) (binb (var 5)  (var 4))))
(define insb-8pp
  '(bina (var 7) (binb (var 5)  (binb  (bina  a  leaf) (var 4)))))
(define pb-8pp
  (patch-make delb-8pp insb-8pp ))
(define o8pp
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r8pp
  '(bina x (binb (bina k leaf ) (binb (bina a leaf ) (binb (bina u leaf ) leaf))) ))
(define tc8pp (list 'tc pa-8pp pb-8pp o8pp r8pp))
(define dela-9nn
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-9nn
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-9nn
  (patch-make dela-9nn insa-9nn ))
(define delb-9nn
  '(bina (var 6) (binb (bina u leaf)  (var 4))))
(define insb-9nn
  '(bina (var 6) (binb (bina U leaf)  (var 4))))
(define pb-9nn
  (patch-make delb-9nn insb-9nn ))
(define o9nn
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r9nn
  '(bina x (binb (bina k leaf ) (binb (bina U leaf ) leaf)) ))
(define tc9nn (list 'tc pa-9nn pb-9nn o9nn r9nn))
(define dela-9ps
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-9ps
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-9ps
  (patch-make dela-9ps insa-9ps ))
(define delb-9ps
  '(bina (var 6) (binb (bina u leaf)  (var 4))))
(define insb-9ps
  '(bina (var 6) (binb (bina U leaf)  (var 4))))
(define pb-9ps
  (patch-make delb-9ps insb-9ps ))
(define o9ps
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r9ps
  '(bina x (binb (bina k leaf ) (binb (bina U leaf ) leaf)) ))
(define tc9ps (list 'tc pa-9ps pb-9ps o9ps r9ps))
(define dela-9pp
  '(bina (var 2) (binb (var 0)  (binb  (var 1) leaf))))
(define insa-9pp
  '(bina (var 2) (binb (var 1)  (binb  (var 0) leaf))))
(define pa-9pp
  (patch-make dela-9pp insa-9pp ))
(define delb-9pp
  '(bina (var 6) (binb (bina u leaf)  (var 4))))
(define insb-9pp
  '(bina (var 6) (binb (bina U leaf)  (var 4))))
(define pb-9pp
  (patch-make delb-9pp insb-9pp ))
(define o9pp
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r9pp
  '(bina x (binb (bina k leaf ) (binb (bina U leaf ) leaf)) ))
(define tc9pp (list 'tc pa-9pp pb-9pp o9pp r9pp))
(define dela-10nn
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-10nn
  '(bina (var 3) (binb (var 1)  (binb  (bina  a  leaf) (var 0)))))
(define pa-10nn
  (patch-make dela-10nn insa-10nn ))
(define delb-10nn
  '(bina (var 8) (binb (var 6)  (var 5))))
(define insb-10nn
  '(bina (var 8) (binb (var 6)  (binb  (bina  b  leaf) (var 5)))))
(define pb-10nn
  (patch-make delb-10nn insb-10nn ))
(define o10nn
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r10nn 'conflict)
(define tc10nn (list 'tc pa-10nn pb-10nn o10nn r10nn))
(define dela-10ps
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-10ps
  '(bina (var 3) (binb (var 1)  (binb  (bina  a  leaf) (var 0)))))
(define pa-10ps
  (patch-make dela-10ps insa-10ps ))
(define delb-10ps
  '(bina (var 8) (binb (var 6)  (var 5))))
(define insb-10ps
  '(bina (var 8) (binb (var 6)  (binb  (bina  b  leaf) (var 5)))))
(define pb-10ps
  (patch-make delb-10ps insb-10ps ))
(define o10ps
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r10ps 'conflict)
(define tc10ps (list 'tc pa-10ps pb-10ps o10ps r10ps))
(define dela-10pp
  '(bina (var 3) (binb (var 1)  (var 0))))
(define insa-10pp
  '(bina (var 3) (binb (var 1)  (binb  (bina  a  leaf) (var 0)))))
(define pa-10pp
  (patch-make dela-10pp insa-10pp ))
(define delb-10pp
  '(bina (var 8) (binb (var 6)  (var 5))))
(define insb-10pp
  '(bina (var 8) (binb (var 6)  (binb  (bina  b  leaf) (var 5)))))
(define pb-10pp
  (patch-make delb-10pp insb-10pp ))
(define o10pp
  '(bina x (binb (bina u leaf ) (binb (bina k leaf ) leaf)) ))
(define r10pp 'conflict)
(define tc10pp (list 'tc pa-10pp pb-10pp o10pp r10pp))
(define dela-11nn
  '(bina (var 1) (binb (var 0)  (binb  (bina  b  leaf) leaf))))
(define insa-11nn
  '(bina (var 1) (binb (var 0)  (binb  (bina  a  leaf) leaf))))
(define pa-11nn
  (patch-make dela-11nn insa-11nn ))
(define delb-11nn
  '(bina (var 4) (binb (var 3)  (binb  (bina  b  leaf) leaf))))
(define insb-11nn
  '(bina (var 4) (binb (var 3)  (binb  (bina  c  leaf) leaf))))
(define pb-11nn
  (patch-make delb-11nn insb-11nn ))
(define o11nn
  '(bina x (binb (bina u leaf ) (binb (bina b leaf ) leaf)) ))
(define r11nn 'conflict)
(define tc11nn (list 'tc pa-11nn pb-11nn o11nn r11nn))
(define dela-11ps
  '(bina (var 1) (binb (var 0)  (binb  (bina  b  leaf) leaf))))
(define insa-11ps
  '(bina (var 1) (binb (var 0)  (binb  (bina  a  leaf) leaf))))
(define pa-11ps
  (patch-make dela-11ps insa-11ps ))
(define delb-11ps
  '(bina (var 4) (binb (var 3)  (binb  (bina  b  leaf) leaf))))
(define insb-11ps
  '(bina (var 4) (binb (var 3)  (binb  (bina  c  leaf) leaf))))
(define pb-11ps
  (patch-make delb-11ps insb-11ps ))
(define o11ps
  '(bina x (binb (bina u leaf ) (binb (bina b leaf ) leaf)) ))
(define r11ps 'conflict)
(define tc11ps (list 'tc pa-11ps pb-11ps o11ps r11ps))
(define dela-11pp
  '(bina (var 1) (binb (var 0)  (binb  (bina  b  leaf) leaf))))
(define insa-11pp
  '(bina (var 1) (binb (var 0)  (binb  (bina  a  leaf) leaf))))
(define pa-11pp
  (patch-make dela-11pp insa-11pp ))
(define delb-11pp
  '(bina (var 4) (binb (var 3)  (binb  (bina  b  leaf) leaf))))
(define insb-11pp
  '(bina (var 4) (binb (var 3)  (binb  (bina  c  leaf) leaf))))
(define pb-11pp
  (patch-make delb-11pp insb-11pp ))
(define o11pp
  '(bina x (binb (bina u leaf ) (binb (bina b leaf ) leaf)) ))
(define r11pp 'conflict)
(define tc11pp (list 'tc pa-11pp pb-11pp o11pp r11pp))
(define dela-12nn
  '(bina (var 0) (binb (bina a leaf)  leaf)))
(define insa-12nn
  '(bina (var 0) (binb (bina j leaf)  leaf)))
(define pa-12nn
  (patch-make dela-12nn insa-12nn ))
(define delb-12nn
  '(bina f (binb (bina a leaf)  leaf)))
(define insb-12nn
  '(bina e leaf))
(define pb-12nn
  (patch-make delb-12nn insb-12nn ))
(define o12nn
  '(bina f (binb (bina a leaf ) leaf) ))
(define r12nn 'conflict)
(define tc12nn (list 'tc pa-12nn pb-12nn o12nn r12nn))
(define dela-12ps
  '(bina (var 0) (binb (bina a leaf)  leaf)))
(define insa-12ps
  '(bina (var 0) (binb (bina j leaf)  leaf)))
(define pa-12ps
  (patch-make dela-12ps insa-12ps ))
(define delb-12ps
  '(bina f (binb (bina a leaf)  leaf)))
(define insb-12ps
  '(bina e leaf))
(define pb-12ps
  (patch-make delb-12ps insb-12ps ))
(define o12ps
  '(bina f (binb (bina a leaf ) leaf) ))
(define r12ps 'conflict)
(define tc12ps (list 'tc pa-12ps pb-12ps o12ps r12ps))
(define dela-12pp
  '(bina (var 0) (binb (bina a leaf)  leaf)))
(define insa-12pp
  '(bina (var 0) (binb (bina j leaf)  leaf)))
(define pa-12pp
  (patch-make dela-12pp insa-12pp ))
(define delb-12pp
  '(bina f (binb (bina a leaf)  leaf)))
(define insb-12pp
  '(bina e leaf))
(define pb-12pp
  (patch-make delb-12pp insb-12pp ))
(define o12pp
  '(bina f (binb (bina a leaf ) leaf) ))
(define r12pp 'conflict)
(define tc12pp (list 'tc pa-12pp pb-12pp o12pp r12pp))
(define dela-13nn
  '(bina d (binb (bina i leaf)  leaf)))
(define insa-13nn
  '(bina a leaf))
(define pa-13nn
  (patch-make dela-13nn insa-13nn ))
(define delb-13nn
  '(bina d (var 2)))
(define insb-13nn
  '(bina a (binb (bina j (var 2))  leaf)))
(define pb-13nn
  (patch-make delb-13nn insb-13nn ))
(define o13nn
  '(bina d (binb (bina i leaf ) leaf) ))
(define r13nn 'conflict)
(define tc13nn (list 'tc pa-13nn pb-13nn o13nn r13nn))
(define dela-13ps
  '(bina d (binb (bina i leaf)  leaf)))
(define insa-13ps
  '(bina a leaf))
(define pa-13ps
  (patch-make dela-13ps insa-13ps ))
(define delb-13ps
  '(bina d (var 2)))
(define insb-13ps
  '(bina a (binb (bina j (var 2))  leaf)))
(define pb-13ps
  (patch-make delb-13ps insb-13ps ))
(define o13ps
  '(bina d (binb (bina i leaf ) leaf) ))
(define r13ps 'conflict)
(define tc13ps (list 'tc pa-13ps pb-13ps o13ps r13ps))
(define dela-13pp
  '(bina d (binb (bina i leaf)  leaf)))
(define insa-13pp
  '(bina a leaf))
(define pa-13pp
  (patch-make dela-13pp insa-13pp ))
(define delb-13pp
  '(bina d (var 2)))
(define insb-13pp
  '(bina a (binb (bina j (var 2))  leaf)))
(define pb-13pp
  (patch-make delb-13pp insb-13pp ))
(define o13pp
  '(bina d (binb (bina i leaf ) leaf) ))
(define r13pp 'conflict)
(define tc13pp (list 'tc pa-13pp pb-13pp o13pp r13pp))
(define dela-14nn
  '(bina k (binb (bina b leaf)  (binb  (var 0) leaf))))
(define insa-14nn
  '(var 0))
(define pa-14nn
  (patch-make dela-14nn insa-14nn ))
(define delb-14nn
  '(bina k (binb (var 2)  (binb  (bina  l  leaf) leaf))))
(define insb-14nn
  '(bina f (binb (bina k leaf)  (binb  (var 2) leaf))))
(define pb-14nn
  (patch-make delb-14nn insb-14nn ))
(define o14nn
  '(bina k (binb (bina b leaf ) (binb (bina l leaf ) leaf)) ))
(define r14nn 'conflict)
(define tc14nn (list 'tc pa-14nn pb-14nn o14nn r14nn))
(define dela-14ps
  '(bina k (binb (bina b leaf)  (binb  (var 0) leaf))))
(define insa-14ps
  '(var 0))
(define pa-14ps
  (patch-make dela-14ps insa-14ps ))
(define delb-14ps
  '(bina k (binb (var 2)  (binb  (bina  l  leaf) leaf))))
(define insb-14ps
  '(bina f (binb (bina k leaf)  (binb  (var 2) leaf))))
(define pb-14ps
  (patch-make delb-14ps insb-14ps ))
(define o14ps
  '(bina k (binb (bina b leaf ) (binb (bina l leaf ) leaf)) ))
(define r14ps 'conflict)
(define tc14ps (list 'tc pa-14ps pb-14ps o14ps r14ps))
(define dela-14pp
  '(bina k (binb (bina b leaf)  (binb  (var 0) leaf))))
(define insa-14pp
  '(var 0))
(define pa-14pp
  (patch-make dela-14pp insa-14pp ))
(define delb-14pp
  '(bina k (binb (var 2)  (binb  (bina  l  leaf) leaf))))
(define insb-14pp
  '(bina f (binb (bina k leaf)  (binb  (var 2) leaf))))
(define pb-14pp
  (patch-make delb-14pp insb-14pp ))
(define o14pp
  '(bina k (binb (bina b leaf ) (binb (bina l leaf ) leaf)) ))
(define r14pp 'conflict)
(define tc14pp (list 'tc pa-14pp pb-14pp o14pp r14pp))
(define dela-15nn
  '(bina i (binb (var 0)  (binb  (bina  c  leaf) leaf))))
(define insa-15nn
  '(var 0))
(define pa-15nn
  (patch-make dela-15nn insa-15nn ))
(define delb-15nn
  '(bina i (binb (bina g leaf)  (binb  (bina  c  leaf) leaf))))
(define insb-15nn
  '(bina g (binb (bina k leaf)  (binb  (bina  l  leaf) leaf))))
(define pb-15nn
  (patch-make delb-15nn insb-15nn ))
(define o15nn
  '(bina i (binb (bina g leaf ) (binb (bina c leaf ) leaf)) ))
(define r15nn 'conflict)
(define tc15nn (list 'tc pa-15nn pb-15nn o15nn r15nn))
(define dela-15ps
  '(bina i (binb (var 0)  (binb  (bina  c  leaf) leaf))))
(define insa-15ps
  '(var 0))
(define pa-15ps
  (patch-make dela-15ps insa-15ps ))
(define delb-15ps
  '(bina i (binb (bina g leaf)  (binb  (bina  c  leaf) leaf))))
(define insb-15ps
  '(bina g (binb (bina k leaf)  (binb  (bina  l  leaf) leaf))))
(define pb-15ps
  (patch-make delb-15ps insb-15ps ))
(define o15ps
  '(bina i (binb (bina g leaf ) (binb (bina c leaf ) leaf)) ))
(define r15ps 'conflict)
(define tc15ps (list 'tc pa-15ps pb-15ps o15ps r15ps))
(define dela-15pp
  '(bina i (binb (var 0)  (binb  (bina  c  leaf) leaf))))
(define insa-15pp
  '(var 0))
(define pa-15pp
  (patch-make dela-15pp insa-15pp ))
(define delb-15pp
  '(bina i (binb (bina g leaf)  (binb  (bina  c  leaf) leaf))))
(define insb-15pp
  '(bina g (binb (bina k leaf)  (binb  (bina  l  leaf) leaf))))
(define pb-15pp
  (patch-make delb-15pp insb-15pp ))
(define o15pp
  '(bina i (binb (bina g leaf ) (binb (bina c leaf ) leaf)) ))
(define r15pp 'conflict)
(define tc15pp (list 'tc pa-15pp pb-15pp o15pp r15pp))
(define dela-16nn
  '(bina g (binb (bina f leaf)  (binb  (var 0) leaf))))
(define insa-16nn
  '(var 0))
(define pa-16nn
  (patch-make dela-16nn insa-16nn ))
(define delb-16nn
  '(bina g (binb (var 2)  (binb  (bina  j  leaf) leaf))))
(define insb-16nn
  '(bina e (binb (bina a leaf)  (binb  (bina  a  leaf) (binb (var 2)  leaf)))))
(define pb-16nn
  (patch-make delb-16nn insb-16nn ))
(define o16nn
  '(bina g (binb (bina f leaf ) (binb (bina j leaf ) leaf)) ))
(define r16nn 'conflict)
(define tc16nn (list 'tc pa-16nn pb-16nn o16nn r16nn))
(define dela-16ps
  '(bina g (binb (bina f leaf)  (binb  (var 0) leaf))))
(define insa-16ps
  '(var 0))
(define pa-16ps
  (patch-make dela-16ps insa-16ps ))
(define delb-16ps
  '(bina g (binb (var 2)  (binb  (bina  j  leaf) leaf))))
(define insb-16ps
  '(bina e (binb (bina a leaf)  (binb  (bina  a  leaf) (binb (var 2)  leaf)))))
(define pb-16ps
  (patch-make delb-16ps insb-16ps ))
(define o16ps
  '(bina g (binb (bina f leaf ) (binb (bina j leaf ) leaf)) ))
(define r16ps 'conflict)
(define tc16ps (list 'tc pa-16ps pb-16ps o16ps r16ps))
(define dela-16pp
  '(bina g (binb (bina f leaf)  (binb  (var 0) leaf))))
(define insa-16pp
  '(var 0))
(define pa-16pp
  (patch-make dela-16pp insa-16pp ))
(define delb-16pp
  '(bina g (binb (var 2)  (binb  (bina  j  leaf) leaf))))
(define insb-16pp
  '(bina e (binb (bina a leaf)  (binb  (bina  a  leaf) (binb (var 2)  leaf)))))
(define pb-16pp
  (patch-make delb-16pp insb-16pp ))
(define o16pp
  '(bina g (binb (bina f leaf ) (binb (bina j leaf ) leaf)) ))
(define r16pp 'conflict)
(define tc16pp (list 'tc pa-16pp pb-16pp o16pp r16pp))
(define dela-17nn
  '(bina e (binb (var 0)  (binb  (var 0) (binb (bina   m   leaf)  leaf)))))
(define insa-17nn
  '(bina j (binb (var 0)  leaf)))
(define pa-17nn
  (patch-make dela-17nn insa-17nn ))
(define delb-17nn
  '(bina e (binb (var 2)  (binb  (var 2) (binb (bina   m   leaf)  leaf)))))
(define insb-17nn
  '(bina j (binb (bina g (binb (bina   c   leaf)  (binb  (bina  c  leaf)   (binb   (bina   h   leaf)  (binb  (var 2)   leaf)))))  leaf)))
(define pb-17nn
  (patch-make delb-17nn insb-17nn ))
(define o17nn
  '(bina e (binb (bina f leaf ) (binb (bina f leaf ) (binb (bina m leaf ) leaf))) ))
(define r17nn
  '(bina j (binb (bina g (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina h leaf ) (binb (bina f leaf ) leaf)))) ) leaf) ))
(define tc17nn (list 'tc pa-17nn pb-17nn o17nn r17nn))
(define dela-17ps
  '(bina e (binb (var 0)  (binb  (var 0) (binb (bina   m   leaf)  leaf)))))
(define insa-17ps
  '(bina j (binb (var 0)  leaf)))
(define pa-17ps
  (patch-make dela-17ps insa-17ps ))
(define delb-17ps
  '(bina e (binb (var 2)  (binb  (var 2) (binb (bina   m   leaf)  leaf)))))
(define insb-17ps
  '(bina j (binb (bina g (binb (bina   c   leaf)  (binb  (bina  c  leaf)   (binb   (bina   h   leaf)  (binb  (var 2)   leaf)))))  leaf)))
(define pb-17ps
  (patch-make delb-17ps insb-17ps ))
(define o17ps
  '(bina e (binb (bina f leaf ) (binb (bina f leaf ) (binb (bina m leaf ) leaf))) ))
(define r17ps
  '(bina j (binb (bina g (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina h leaf ) (binb (bina f leaf ) leaf)))) ) leaf) ))
(define tc17ps (list 'tc pa-17ps pb-17ps o17ps r17ps))
(define dela-17pp
  '(bina e (binb (bina (var 1) leaf)  (binb  (bina  f  leaf) (binb (bina   m   leaf)  leaf)))))
(define insa-17pp
  '(bina j (binb (bina (var 1) leaf)  leaf)))
(define pa-17pp
  (patch-make dela-17pp insa-17pp ))
(define delb-17pp
  '(bina e (binb (bina f leaf)  (binb  (bina  f  leaf) (binb (bina   m   leaf)  leaf)))))
(define insb-17pp
  '(bina j (binb (bina g (binb (bina   c   leaf)  (binb  (bina  c  leaf)   (binb   (bina   h   leaf)  (binb  (bina    f    leaf)   leaf)))))  leaf)))
(define pb-17pp
  (patch-make delb-17pp insb-17pp ))
(define o17pp
  '(bina e (binb (bina f leaf ) (binb (bina f leaf ) (binb (bina m leaf ) leaf))) ))
(define r17pp
  '(bina j (binb (bina g (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina h leaf ) (binb (bina f leaf ) leaf)))) ) leaf) ))
(define tc17pp (list 'tc pa-17pp pb-17pp o17pp r17pp))
(define dela-18nn
  '(bina (var 1) (binb (var 0)  (binb  (bina  c  leaf) leaf))))
(define insa-18nn
  '(bina (var 1) (binb (var 0)  (binb  (var 0) leaf))))
(define pa-18nn
  (patch-make dela-18nn insa-18nn ))
(define delb-18nn
  '(bina (var 5) (binb (bina a leaf)  (var 4))))
(define insb-18nn
  '(bina (var 5) (binb (bina b leaf)  (var 4))))
(define pb-18nn
  (patch-make delb-18nn insb-18nn ))
(define o18nn
  '(bina r (binb (bina a leaf ) (binb (bina c leaf ) leaf)) ))
(define r18nn
  '(bina r (binb (bina b leaf ) (binb (bina b leaf ) leaf)) ))
(define tc18nn (list 'tc pa-18nn pb-18nn o18nn r18nn))
(define dela-18ps
  '(bina (var 1) (binb (var 0)  (binb  (bina  c  leaf) leaf))))
(define insa-18ps
  '(bina (var 1) (binb (var 0)  (binb  (var 0) leaf))))
(define pa-18ps
  (patch-make dela-18ps insa-18ps ))
(define delb-18ps
  '(bina (var 5) (binb (bina a leaf)  (var 4))))
(define insb-18ps
  '(bina (var 5) (binb (bina b leaf)  (var 4))))
(define pb-18ps
  (patch-make delb-18ps insb-18ps ))
(define o18ps
  '(bina r (binb (bina a leaf ) (binb (bina c leaf ) leaf)) ))
(define r18ps
  '(bina r (binb (bina b leaf ) (binb (bina b leaf ) leaf)) ))
(define tc18ps (list 'tc pa-18ps pb-18ps o18ps r18ps))
(define dela-18pp
  '(bina (var 1) (binb (bina (var 2) leaf)  (binb  (bina  c  leaf) leaf))))
(define insa-18pp
  '(bina (var 1) (binb (bina (var 2) leaf)  (binb  (bina  a  leaf) leaf))))
(define pa-18pp
  (patch-make dela-18pp insa-18pp ))
(define delb-18pp
  '(bina (var 6) (binb (bina a leaf)  (var 5))))
(define insb-18pp
  '(bina (var 6) (binb (bina b leaf)  (var 5))))
(define pb-18pp
  (patch-make delb-18pp insb-18pp ))
(define o18pp
  '(bina r (binb (bina a leaf ) (binb (bina c leaf ) leaf)) ))
(define r18pp
  '(bina r (binb (bina b leaf ) (binb (bina a leaf ) leaf)) ))
(define tc18pp (list 'tc pa-18pp pb-18pp o18pp r18pp))
(define dela-19nn
  '(bina (var 0) (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insa-19nn
  '(bina (var 0) (binb (bina c leaf)  leaf)))
(define pa-19nn
  (patch-make dela-19nn insa-19nn ))
(define delb-19nn
  '(bina c (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insb-19nn
  '(bina f (binb (bina c leaf)  (binb  (bina  c  leaf) (binb (bina   c   leaf)  (binb  (bina  k  leaf)   leaf))))))
(define pb-19nn
  (patch-make delb-19nn insb-19nn ))
(define o19nn
  '(bina c (binb (bina m (binb (bina a leaf ) leaf) ) leaf) ))
(define r19nn
  '(bina f (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina k leaf ) leaf)))) ))
(define tc19nn (list 'tc pa-19nn pb-19nn o19nn r19nn))
(define dela-19ps
  '(bina (var 0) (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insa-19ps
  '(bina (var 0) (binb (bina c leaf)  leaf)))
(define pa-19ps
  (patch-make dela-19ps insa-19ps ))
(define delb-19ps
  '(bina c (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insb-19ps
  '(bina f (binb (bina c leaf)  (binb  (bina  c  leaf) (binb (bina   c   leaf)  (binb  (bina  k  leaf)   leaf))))))
(define pb-19ps
  (patch-make delb-19ps insb-19ps ))
(define o19ps
  '(bina c (binb (bina m (binb (bina a leaf ) leaf) ) leaf) ))
(define r19ps
  '(bina f (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina k leaf ) leaf)))) ))
(define tc19ps (list 'tc pa-19ps pb-19ps o19ps r19ps))
(define dela-19pp
  '(bina (var 0) (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insa-19pp
  '(bina (var 0) (binb (bina c leaf)  leaf)))
(define pa-19pp
  (patch-make dela-19pp insa-19pp ))
(define delb-19pp
  '(bina c (binb (bina m (binb (bina   a   leaf)  leaf))  leaf)))
(define insb-19pp
  '(bina f (binb (bina c leaf)  (binb  (bina  c  leaf) (binb (bina   c   leaf)  (binb  (bina  k  leaf)   leaf))))))
(define pb-19pp
  (patch-make delb-19pp insb-19pp ))
(define o19pp
  '(bina c (binb (bina m (binb (bina a leaf ) leaf) ) leaf) ))
(define r19pp
  '(bina f (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina c leaf ) (binb (bina k leaf ) leaf)))) ))
(define tc19pp (list 'tc pa-19pp pb-19pp o19pp r19pp))

(define tests 
  (list tc1nn
        tc1ps
        tc1pp
        tc2nn
        tc2ps
        tc2pp
        tc3nn
        tc3ps
        tc3pp
        tc4nn
        tc4ps
        tc4pp
        tc5nn
        tc5ps
        tc5pp
        tc6nn
        tc6ps
        tc6pp
        tc7nn
        tc7ps
        tc7pp
        tc8nn
        tc8ps
        tc8pp
        tc9nn
        tc9ps
        tc9pp
        tc10nn
        tc10ps
        tc10pp
        tc11nn
        tc11ps
        tc11pp
        tc12nn
        tc12ps
        tc12pp
        tc13nn
        tc13ps
        tc13pp
        tc14nn
        tc14ps
        tc14pp
        tc15nn
        tc15ps
        tc15pp
        tc16nn
        tc16ps
        tc16pp
        tc17nn
        tc17ps
        tc17pp
        tc18nn
        tc18ps
        tc18pp
        tc19nn
        tc19ps
        tc19pp
  ))

