;; models the transference of colorism in one direction, police learn from cpolice.
;; Written in NetLogo
;; Author: Henry Smart
;; Creation Date: December 3, 2016

globals [
  free-patches             ;; space, group of patches that represent the ideal (free) space for citizen-agents
  detainment-patches       ;; space, group of patches that represent the detainment area for citizen-agents
  incarceration-patches    ;; space, group of patches that represent the incarceration area for citizen-agents
]

;;citizen agents
breed [darks dark]         ;;represenative of dark skin color
breed [mediums medium]     ;;representative of medium skin color
breed [lights light]       ;;represenative of light skin color

;;police agents
breed [cpolices cpolice]   ;;police officers influenced by colorism
breed [polices police]     ;;police officers not influenced by colorism

;;rap - represents a citizen-agent's rapsheet, increases with each detainment
darks-own [rap]
mediums-own [rap]
lights-own [rap]

;;convert counter - keeps track of the interactions between police and cpolice. Once a police covert-counter reaches a count of 2, the decision making model coverts from police to cpolice.

polices-own [convert]
cpolices-own [convert]

to setup
  clear-all

  ;; create free-patches
  set free-patches patches with [pycor >= 1 and pycor <= 30]
  ask free-patches [ set pcolor white ]

  ;; create detainment-patches
  set detainment-patches patches with [pycor >= -9 and pycor <= 0]
  ask detainment-patches [ set pcolor orange ]

  ;; create incarceration-patches
  set incarceration-patches patches with [pycor >= -30 and pycor <= -10]
  ask incarceration-patches [ set pcolor red ]

  ;;create citizen-agents (darks, mediums and lights) and police-agents (polices and cpolices)

  create-darks #-of-darks [          ;;creates citizen-gents with dark skin color
    set shape "person"
    set rap 0
    set size 1
    set color black
    set label rap
    set label-color red
    move-to one-of free-patches with [count turtles-here = 0]
    ]

  create-mediums #-of-mediums [      ;;creates citizen-gents with medium skin color
    set shape "person"
    set rap 0
    set size 1
    set color brown
    set label rap
    set label-color red
    move-to one-of free-patches with [count turtles-here = 0]
    ]

  create-lights #-of-lights [        ;;creates citizen-gents with light skin color
    set shape "person"
    set rap 0
    set size 1
    set color yellow
    set label rap
    set label-color red
    move-to one-of free-patches with [count turtles-here = 0]
    ]

  create-cpolices #-of-cpolice [     ;;creates police-agents influenced by colorism
    set shape "police"
    set size 1
    set color red
    set convert 2
    move-to one-of free-patches with [count turtles-here = 0]
    ]

  create-polices #-of-police [       ;;creates police-agents not influenced by colorism
    set shape "police"
    set size 1
    set color green
    set convert 0
    move-to one-of free-patches with [count turtles-here = 0]
    ]

  reset-ticks

end


to go

  ask darks [
    set label rap
    set label-color red
    ]

  ask mediums [
    set label rap
    set label-color red
    ]

  ask lights [
    set label rap
    set label-color red
    ]

  ask cpolices [                                                                    ;;starts cpolicing of the free-patches
    move-to one-of free-patches
    ]

  ask polices [                                                                     ;;starts policing of the free-patches
    move-to one-of free-patches
    ]

  ask polices [                                                                     ;;increases polices convert counter by 1
    if any? cpolices
    in-radius 1
    [set convert convert + 1]
    ]

  ask polices [                                                                     ;;converts police to cpolice after two interactions
    if convert >= 2 [
    set breed cpolices
    set shape "police"
    set color red
    ]]

  ask darks                                                                         ;;procedure for detainment of darks by cpolice and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = red and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 2]
    ]

  ask mediums                                                                       ;;procedure for detainment of mediums by cpolice and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = red and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 1]
    ]

  ask lights                                                                        ;;procedure for detainment of lights by cpolice and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = red and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 0.75]
    ]

  ask darks                                                                         ;;procedure for detainment of darks by police and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = green and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 1]
    ]

  ask mediums                                                                       ;;procedure for detainment of mediums by police and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = green and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 1]
    ]

  ask lights                                                                        ;;procedure for detainment of lights by police and intiation of rapsheet tally
    with[pcolor = white] [
    if any? turtles with [shape = "police" and color = green and pcolor = white]
    in-radius 1
    [move-to one-of detainment-patches set rap rap + 1]
    ]

  ask turtles                                                                       ;;returns detained citizen-agents to free-society
    with [pcolor = orange and shape = "person"][
    move-to one-of free-patches forward 2]

  ask turtles                                                                       ;;incarcerates citizen-agents based on a three-strike rule
    with [pcolor = white and shape = "person"][
    if rap >= 3 [
    move-to one-of incarceration-patches]
    ]

if not any? turtles with [pcolor = white and shape = "person"] [stop]

  tick

end
@#$#@#$#@
GRAPHICS-WINDOW
170
10
967
828
30
30
12.902
1
10
1
1
1
0
0
0
1
-30
30
-30
30
1
1
1
ticks
30.0

BUTTON
-1
10
63
43
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
-1
53
62
86
NIL
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
-2
97
61
130
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
138
172
171
#-of-lights
#-of-lights
0
800
800
1
1
NIL
HORIZONTAL

SLIDER
0
172
172
205
#-of-mediums
#-of-mediums
0
320
320
1
1
NIL
HORIZONTAL

SLIDER
0
205
172
238
#-of-darks
#-of-darks
0
269
269
1
1
NIL
HORIZONTAL

SLIDER
-2
241
170
274
#-of-cpolice
#-of-cpolice
0
25
25
1
1
NIL
HORIZONTAL

SLIDER
-7
280
165
313
#-of-police
#-of-police
0
25
6
1
1
NIL
HORIZONTAL

PLOT
967
132
1236
252
Plight of the Darks
Time
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Free" 1.0 0 -16777216 true "" "plot count darks with [pcolor = white]"
"Incarcerated" 1.0 0 -2674135 true "" "plot count darks with [pcolor = red]"

PLOT
966
256
1236
376
Plight of the Mediums
Time
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Free" 1.0 0 -16777216 true "" "plot count mediums with [pcolor = white]"
"Incarcerated" 1.0 0 -2674135 true "" "plot count mediums with [pcolor = red]"

PLOT
967
381
1236
501
Plight of the Lights
Time
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Free" 1.0 0 -16777216 true "" "plot count lights with [pcolor = white]"
"Incarcerated" 1.0 0 -2674135 true "" "plot count lights with [pcolor = red]"

PLOT
967
10
1236
130
# of Police and C-Police
Time
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"C-Police" 1.0 0 -2674135 true "" "plot count cpolices with [pcolor = white]"
"Police" 1.0 0 -16777216 true "" "plot count polices with [pcolor = white]"

@#$#@#$#@
## WHAT IS IT?

This project models the policing behavior of two types of local-level police-agents based on the phenomena of colorism.  Colorism is the preferential treatment of people with light skin and discrimination against people with dark skin (Russell et al 2013).  The red police-agents (c-police) represent police officers whose policing decisions are influenced by colorism. The green police-agents (police) represent police officers whose policing decisions are not influenced by colorism.  The three breeds of citizen-agents (darks, mediums, and lights) represent the complete skin color spectrum of the citizenry.  The patch space is divided into three zones. The top zone, represented by white patches, is the ideal space-free society. The middle zone, represented by orange patches, is the detainment space.  The detainment space represents all criminal justice functions except for incarceration.  The bottom zone, represented by red patches, is the incarceration space.  The incarceration space represents imprisonment.  The simulation demonstrates how individual policing decisions, biased or not, might impact long-term incarceration outcomes.  In addition, the simulation demonstrates the role that organizational socialization plays in the transference of colorism.  The project draws from several streams of logic, which include colorism, risk perception and organizational socialization.

## HOW IT WORKS / HOW TO USE IT

Click the SETUP button to stage the model. Adjust the number of c-police, police, darks, mediums and lights to a preferred number.  Ticks represent an abstract unit of time.  Click the GO button to start the simulation with one time tick.  Click the GO - continuous button to start the simulation with continuous time ticks.  There are two major functions of the model, policing and the transfer of biased decision-making models.

POLICING
At each tick, police randomly patrol the free space with an attempt to make an arrest.  If there are no available citizens to arrest (citizens located one patch away from the officer in all four directions-north, south, east and west), the police officer will move to the next random patch/cell in the free space.  At the time of an arrest, the citizen-agents that reside on the four neighboring patches (north, south, east and west) of the arresting officer will receive a charge.  A (biased) c-police adds two (2) charges to a dark citizen's rap-sheet, one (1) charge to a medium citizen's rap-sheet and 3/4 (0.75) of a charge to a light citizen's rap-sheet.  A (fair) police adds one (1) charge to all four surrounding citizen-agents regardless of their skin color.  Each time a citizen is arrested they will move to the detainment area for one tick and immediately return to a random patch/cell in the free space.  Once a citizen's rap-sheet is equal to or goes beyond three (3) charges, the citizen will be permanently placed in the incarceration space.

TRANSFER OF BIASED DECISION-MAKING MODELS / ORGANIZATIONAL SOCIALIZATION
The rules are intended to simulate the transfer of bias from one police officer to another.  At each tick, a (fair) police checks to see if there is a c-police within close proximity (1 patch/cell).  If this condition is true, the police's convert counter is increased by 1.  Once the convert counter reaches 2, a (fair) police will be converted to a (biased) c-police.

STOPPING THE MODEL
The model will stop running if the Go - continuous button is pressed a second time, or when the free space no longer contains citizen-agents.

## THINGS TO NOTICE

There are four plots to the right of activity area.  The top plot tracks the number of (biased) c-police to (fair) police. As police-to-c-police conversion [transference] takes place, pay attention to what happens in the plight plots. You should see a strong correlation between the conversions and the plight of dark citizens and a moderate correlation between the conversions and medium citizens.  However, this may not occur if some of the initial slider settings are skewed too far to the left or right.

The plight plot comparisons enable the detection of shifts in the free population and the incarcerated population.  Take notice of the varied results.

## THINGS TO TRY

MODELING BASED ON THE U.S. POPULATION
To emulate the U.S. population size, use these numbers for your staging: 796 lights, 218 mediums, 167 darks, 1 c-police and 2 police (or 2 c-police and 1 police).

THE TRANSFERENCE OF COLORISM
To model an equal starting point of fair and biased policing, set the c-police and police sliders to the same number (e.g., c-police = 20 and police = 20). Transference of colorism is somewhat easier to observe when there is an equal number of c-police and police.

TOTAL FAIR-POLICING
To model absolute fair-policing, set the slider for c-police to zero (0) and select a random setting (other than zero) for the police slider.

TOTAL BIASED-POLICING
To model absolute biased-policing, set the slider for police to zero (0) and select a random setting (other than zero) for the c-police slider.

## EXTENDING THE MODEL

This model was developed by a novice coder, so there is plenty of opportunity to extend the model. Firstly, coders are encouraged to flatten the code. In its current state, no bugs were detected, but a more concise code-set may add validity to the model.

In its current state, the model can only simulate a few theories.  Coders should consider other theories, such as the effects of the "return to free society", the outcomes of fair policing but biased "return to free society" or any combination of the available policing and justice theories.

## RELATED MODELS

Those interested in the topic of colorism or population outcomes should also review the segregation model (http://ccl.northwestern.edu/netlogo/models/Segregation).

## CREDITS AND REFERENCES

Credit:  Reese, Dean. YouTube, (2014) if then 3 in NetLogo.
         https://www.youtube.com/watch?v=gOEKr0cnKXw#t=78.82102

Credit:  Reese, Dean. YouTube, (2014) in-radius die in NetLogo.
         https://www.youtube.com/watch?v=eQO92ZvaP-Q

Credit:  Rand, W., Wilensky, U. (2007). NetLogo El Farol model.
         http://ccl.northwestern.edu/netlogo/models/ElFarol. Center for Connected
         Learning and Computer-Based Modeling, Northwestern Institute on Complex
         Systems, Northwestern University, Evanston, IL.

Credit:  Wilensky, U. (1997).  NetLogo Segregation model.
         http://ccl.northwestern.edu/netlogo/models/Segregation. Center for Connected
         Learning and Computer-Based Modeling, Northwestern University, Evanston,
         IL.

Reference: Russell, K., Wilson, M., & Hall, R. (2013). The color complex (revised): The             politics of skin color in a new millennium. Anchor.

Reference: Van Maanen, J. (1975). Police socialization: A longitudinal examination of
	   job attitudes in an urban police department. Administrative Science
	   Quarterly, 207-228.

Reference: Lupton, D. (1999). Risk: key ideas. Risk: key ideas. Routledge.

Creation Date: 4/9/16
Last Updated: 10/26/17
Author: Henry Smart, III
Email: hsmartiii@gmail.com

Notes: This model was designed using NetLogo 5.3.1. The author can be reached via email at hsmartiii@gmail.com.  If you use any portion of this model, please properly site the project and the author.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

police
false
0
Circle -7500403 false true 45 45 210
Polygon -7500403 true true 96 225 150 60 206 224 63 120 236 120
Polygon -7500403 true true 120 120 195 120 180 180 180 185 113 183
Polygon -7500403 false true 30 15 0 45 15 60 30 90 30 105 15 165 3 209 3 225 15 255 60 270 75 270 99 256 105 270 120 285 150 300 180 285 195 270 203 256 240 270 255 270 285 255 294 225 294 210 285 165 270 105 270 90 285 60 300 45 270 15 225 30 210 30 150 15 90 30 75 30

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Logic 1 - Equal Number of CPolice and Police" repetitions="50" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 2 - More CPolice than Police" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 3 - More Police than CPolice" repetitions="50" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if all? darks [pcolor = red] [stop]</final>
    <timeLimit steps="1500"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <metric>(count darks with [pcolor = red] / count darks with [pcolor = white])</metric>
    <metric>(count mediums with [pcolor = red] / count mediums with [pcolor = white])</metric>
    <metric>(count lights with [pcolor = red] / count lights with [pcolor = white])</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 4 - Total Biased Policing" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Lgoic 5 - Total Fair Policing" repetitions="50" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="393"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 6 - U.S. Population - Equal Number of CPolice and Police" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="796"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="218"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="167"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 7 - U.S. Population - More CPolice than Police" repetitions="50" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-darks">
      <value value="167"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="218"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-lights">
      <value value="796"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 8 - U.S. Population - More Police than CPolice" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="796"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="218"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="167"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 9 - U.S. Population - Total Biased Policing" repetitions="50" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="796"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="218"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="167"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Logic 10 - U.S. Population - Total Fair Policing" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>if not any? turtles with [pcolor = white and shape = "person"] [stop]</final>
    <timeLimit steps="4000"/>
    <metric>count cpolices with [pcolor = white]</metric>
    <metric>count polices with [pcolor = white]</metric>
    <metric>count darks with [pcolor = white]</metric>
    <metric>count darks with [pcolor = red]</metric>
    <metric>count mediums with [pcolor = white]</metric>
    <metric>count mediums with [pcolor = red]</metric>
    <metric>count lights with [pcolor = white]</metric>
    <metric>count lights with [pcolor = red]</metric>
    <enumeratedValueSet variable="#-of-lights">
      <value value="796"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-mediums">
      <value value="218"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-darks">
      <value value="167"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-cpolice">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#-of-police">
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
