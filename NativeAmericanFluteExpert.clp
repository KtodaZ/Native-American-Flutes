;Native American Flute Expert
;by Gabe Castlebary & Kyle Szombathy Spring 2017 - CSC180

;*********************************
;Gather information from the user
;*********************************
(defrule woodType
 (start)
 => 
 (printout t "What type of wood are you using?" crlf)
 (printout t "--(oak, cedar, redwood, canary, purple-heart, babinga, mahogany)--" crlf)
 (assert (woodType (read))))

(defrule desiredTone
 (start)
 =>
  (printout t "What kind of tone do you want?" crlf)
  (printout t "--silver, midrange, mellow--" crlf)
  (assert (desiredTone (read))))

 
(defrule fluteHalvesFinish
 (start)
 =>
  (printout t "Are the flute blanks nicely finished?" crlf)
  (printout t "--(yes, no)--" crlf)
  (assert (fluteHalves (read)))
  (retract 1))
  
(defrule Get_Observations
 ?i <- (initial-fact)
 (tuning yes)
 =>
 (printout t "How many cents relative to your desired frequency (-50 to +50) are you off by? ")
 (bind ?response (read))
 (assert (crispCents ?response))
 (printout t "What is the temperature of your instrument? (0-40 Celsius) ")
 (bind ?response (read))
 (assert (crispTemp ?response))
 (retract ?i))

  

;*********************************
;Process User Input
;*********************************
(defrule hardness1
 (woodType oak)
 =>
  (assert (woodHardness soft))
  (assert (glueType extra-strength)))

(defrule hardness2 
  (woodType cedar)
  =>
   (assert (woodHardness soft))
   (assert (glueType normal)))

(defrule hardness3
 (woodType redwood)
  =>
   (assert (woodHardness soft))
   (assert (glueType normal)))

(defrule hardness4
 (woodType canary)
 =>
  (assert (woodHardness hard))
  (assert (glueType normal)))
  
(defrule hardness5
 (woodType purple-heart)
 =>
  (assert (woodHardness hard))
  (assert (glueType normal)))

(defrule hardness6
 (woodType babinga)
 =>
  (assert (woodHardness hard))
  (assert (glueType normal)))
  
(defrule hardness7
 (woodType mahogany)
 =>
  (assert (woodHardness hard))
  (assert (glueType normal)))

  
  

(defrule lengthConstraints1
 (desiredTone silver)
 =>
  (assert (airChamber 2.5)))

(defrule lengthConstraints2
 (desiredTone mellow)
 =>
  (assert (airChamber 3.5))) 
  
(defrule lengthConstraints3
 (desiredTone midrange)
 =>
  (assert (airChamber 3.0)))

  
  
  
(defrule constructionTime1
 (woodHardness hard)
 =>
  (assert (constructionTime 24)))

(defrule constructionTime2
 (woodHardness soft)
 =>
  (assert (constructionTime 16)))

  
  
(defrule oakSpecialCase1
 (woodType oak)
 =>
  (assert (glueType extra-strength)))

(defrule oakSpecialCase2
 (woodType oak)
 (fluteHalves no)
 =>
  (assert (done no))
  (retract 2))
  
  
  

(defrule airRamp1
 (desiredTone silver)
 =>
  (assert (air-ramp 35)))

(defrule airRamp2
 (desiredTone mellow)
 =>
  (assert (air-ramp 55)))
  
(defrule airRamp3
 (desiredTone midrange)
 =>
  (assert (air-ramp 45)))


;*********************************
;Result List & Output
;*********************************
(defrule done
 (constructionTime ?)
 (glueType ?)
 (airChamber ?)
 (air-ramp ?)
 (woodType ?)
 (woodHardness ?)
 (desiredTone ?)
 (fluteHalves ?)
 =>
   (assert (done yes)))
 
(defrule conclusion1
 (done yes)
 (constructionTime ?makeTime)
 (glueType ?gType)
 (airChamber ?airC)
 (air-ramp ?airR)
 (woodType ?woodKind)
 (woodHardness ?hardnes)
 (desiredTone ?toned)
 (fluteHalves ?flutehal)
 =>
  (printout t "Here is the results for your flute!" crlf)
  (printout t "Wood Type: " ?woodKind " is a " ?hardnes " wood!" crlf)
  (printout t "Glue Type: " ?gType crlf)
  (printout t "Expected Construction Time: " ?makeTime crlf)
  (printout t "For your Desired Tone: " ?toned crlf)
  (printout t "Create a " ?airC " inch air chamber" crlf)
  (printout t "Create an air ramp with a " ?airR " angle." crlf)
  (printout t "Tuning Action:" crlf)
  (assert (tuning yes)))
  
(defrule conclusion2
 (done no)
 =>
  (printout t "You have a bad flute blank!  Start over!" crlf))
 
;*********************************
;Assert Facts on Start
;*********************************
(deffacts startup
 (start))
 
 
 
 
 

;*********************************
;fuzzy stuff
;*********************************
;; Fuzzy Set definition

(deftemplate Tuning
   -50 50 cents
  ( (Neg (-20 1) (-5 0))
    (Zer (-5 0) (0 1) (5 0))
    (Pos (5 0) (6 1))))
    
(deftemplate Temp
    0 40 C
    ( (Neg (0 1) (20 0) )
      (Zer (20 0) (22 1) (24 0))
      (Pos (24 0) (40 1))))


(deftemplate HoleMod
 -15 15 mm
 ( (N (-15 1) (0 0))
 (Z (0 0) )
 (P (0 0) (15 1)))) 

;; fuzzify the inputs
(defrule fuzzify
 (crispCents ?c)
 (crispTemp ?t)
 =>
 (assert (Tuning (?c 0) (?c 1) (?c 0)))
 (assert (Temp (?t 0) (?t 1) (?t 0)))
)

;; defuzzify the outputs
(defrule defuzzify1
 (declare (salience -1))
 ?f <- (HoleMod ?)
 =>
 (bind ?t (maximum-defuzzify ?f))
 (printout t "--> " ?t mm crlf ))

 
;; FAM rule definition

(defrule PP
 (Tuning Pos)
 (Temp Pos)
 =>
 (printout t "You cut away too much material. If possible, make the bore hole smaller by")
 (assert (HoleMod P)))
 
(defrule PZ
 (Tuning Pos)
 (Temp Zer)
 =>
 (printout t "You cut away too much material. If possible, make the bore hole smaller by")
 (assert (HoleMod P)))
 
(defrule PN
 (Tuning Pos)
 (Temp Neg)
 =>
 (printout t "You're in tune")
 (assert (HoleMod Z)))
 
(defrule ZP
 (Tuning Zer)
 (Temp Pos)
 =>
 (printout t "You cut away too much material. If possible, make the bore hole smaller by")
 (assert (HoleMod P)))
 
(defrule ZZ
 (Tuning Zer)
 (Temp Zer)
 =>
 (printout t "You're in tune!")
 (assert (HoleMod Z)))
 
(defrule ZN
 (Tuning Zer)
 (Temp Neg)
 =>
 (printout t "Burn or drill")
 (assert (HoleMod N)))
 
(defrule NP
 (Tuning Neg)
 (Temp Pos)
 =>
 (printout t "You're in tune!")
 (assert (HoleMod Z)))
 
(defrule NZ
 (Tuning Neg)
 (Temp Zer)
 =>
 (printout t "Burn or drill")
 (assert (HoleMod N)))
 
(defrule NN
 (Tuning Neg)
 (Temp Neg)
 =>
 (printout t "Drill")
 (assert (HoleMod N)))