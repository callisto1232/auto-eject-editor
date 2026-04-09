
;===== Auto-Clear Centauri Carbon, Modified =====================
M400 ;Wait for current moves to finish
M140 S0 ;Turn-off bed
M106 S255 ; turn on Heatbreak Fan
M83 ;Set extruder to relative mode
G92 E0 ;Zero the extruder (Counter reset ONLY, NO physical retraction)

; Lift Z slightly moving in arc, NO E-1 retraction parameter included
G2 I1 J0 Z{max_layer_z+0.5} F3000 
G90 ;Absolute positioning mode

; Move print head up out of the way safely
{if max_layer_z > 50}G1 Z{min(max_layer_z+50, printable_height+0.5)} F20000{else}G1 Z100 F20000 {endif}
M204 S5000 ;Set acceleration for normal moves
M400 ;Wait for current moves to finish

; --- PARK IN POOP ZONE ---
G1 X202 F20000 ;move to X=202 absolute
M400 ;Wait for current moves to finish
G1 Y250 F20000 ;move to Y=250 absolute
G1 Y264.5 F1200 ;move to Y=264.5 absolute (parking precisely over the chute)
M400 ;Wait for current moves to finish

M104 S0 ;Turn-off hotend

; --- DEEP FREEZE PHASE ---
;turn on every fan to cool off quicker
G1 Z0 F1000 ;move bed to absolute zero
M106 S255 ; turn on Model Fan
M106 P2 S255 ; turn on Side Fan
M106 P3 S255 ; turn on Chamber Fan
M190 S35 ;Wait for bed temperature to drop to 35*c
M140 S0 ;Turn-off bed completely

; --- FLEX & POP PHASE (Toolhead waits in poop zone during this) ---
G90 ;Absolute positioning
G1 Z220 F1200 ;Move printbed down to nearly the maximum
G1 Z245 F300 ;Move printbed down to hit the flex bar and pop off print
G4 S4 ;Pause for 4 seconds
G1 Z225 F1200 ;Move printbed up slightly to release tension
G1 Z245 F600 ;Move printbed down to pop off print again (second bounce)
G4 S2 ;Pause for 2 seconds
G1 Z225 F1200 ;Move printbed up
G4 S2 ;Pause for 2 seconds
M400 ;Wait for current moves to finish

;Phase 1
; ---  HEAD PHASE ---
G1 X70 Y230 F4000 ; Move to the back-center (X128, Y250) BEFORE bringing the bed up
G1 Z2 F1200 ; Bring bed up to Z=2.5mm (optimal height)

; SWEEP ACTION
G1 Y1 F2500 ; Sweep forward aggressively to push the part out the front door
G1 Y250 F10000 ; Move toolhead all the way back out of the way
M400 ; waiting for movenets finish 

;Phase 2
; ---  HEAD PHASE ---
G1 X170 Y250 F4000 ; Move to the back-center (X128, Y250) BEFORE bringing the bed up
G1 Z2 F1200 ; Bring bed up to Z=2.5mm (optimal height)

; SWEEP ACTION
G1 Y1 F2500 ; Sweep forward aggressively to push the part out the front door
G1 Y250 F10000 ; Move toolhead all the way back out of the way
M400 ; waiting for movenets finish 


; --- SHUTDOWN PHASE ---
; --- PARK IN POOP ZONE ---
G1 X202 F20000 ;move to X=202 absolute
M400 ;Wait for current moves to finish
G1 Y250 F20000 ;move to Y=250 absolute
G1 Y264.5 F1200 ;move to Y=264.5 absolute (parking precisely over the chute)
M400 ;Wait for current moves to finish
G1 Y264.5 F1200 ; park in filament chute
M400 ; Wait for current moves to finish

M140 S0 ; turn-off bed
M106 S0 ; turn off Model Fan
M106 P2 S0 ; turn off Side Fan
M106 P3 S0 ; turn off Chamber Fan

G4 S5 ;give the operator 30s to pause print if manual intervention is needed

M73 P99 R0

;---------- Comment out M84 if this is NOT the end of your file -------------
M84 ;disable steppers
;---------- Comment out M84 if this is NOT the end of your file -------------
