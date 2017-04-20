;Wearing Clothes
;by Gabe Castlebary & Kyle Szombathy Spring 2017 - CSC180

;GATHERING
(defrule p1
 ?p <- (start)
 =>
 (printout t "Is it 'warm' / 'cold'? ")
 (assert (temp (read))))
 
(defrule p2
 ?p <- (start)
 =>
 (printout t "Is it 'sunny' / 'rainy'? ")
 (assert (weather (read))))

(defrule p3
 ?p <- (start)
 =>
  (printout t "Is it 'windy' / 'calm'? ")
  (assert (wind (read)))
  (retract ?p)
  (retract 0))


;PROCESS

(defrule tops1
  (temp cold)
  (weather rainy)
  (wind ?)
 =>
  (assert (shirt long-sleave)))

(defrule tops2
  (temp cold)
  (weather ?)
  (wind windy)
 =>
  (assert (shirt long-sleave)))

(defrule tops3
  (temp cold)
  (weather sunny)
  (wind calm)
 =>
  (assert (shirt short-sleave)))

(defrule tops4
  (temp warm)
  (weather ?)
  (wind ?)
 =>
  (assert (shirt short-sleave)))
  
(defrule bottoms1
  (temp warm)
  (weather sunny)
  (wind ?)
 =>
  (assert (bottoms shorts)))

(defrule bottoms2
  (temp warm)
  (weather ?)
  (wind calm)
 =>
  (assert (bottoms shorts)))

(defrule bottoms3
  (temp cold)
  (weather ?)
  (wind windy)
 =>
  (assert (bottoms pants)))

(defrule bottoms4
  (temp ?)
  (weather rainy)
  (wind windy)
 =>
  (assert (bottoms pants)))
  
(defrule bottoms5
  (temp ?)
  (weather ?)
  (wind windy)
 =>
  (assert (bottoms pants)))

(defrule umb
  (weather rainy)
 =>
  (assert (umbrella yes)))
 
(defrule umb
  (weather sunny)
  =>
   (assert (umbrella no)))

   
;CONCLUSION
(defrule conclusion
  (shirt ?tops)
  (bottoms ?bottoms)
  (umbrella ?umbr)
 =>
  (printout t "Wear a " ?tops " shirt." crlf)
  (printout t "Wear " ?bottoms "." crlf)
  (printout t "Umbrella needed - " ?umbr "." crlf))
  

(deffacts startup
 (start))