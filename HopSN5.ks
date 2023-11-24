// Hop script for SN5 (controlled TWR on ascent, hover and landing.)

// Variables
set proginit to false.
set loggingEnabled to true.

print "SN5 Hop Program loaded.".

wait 1.

print "Program init in progress".

// Init
lock throttle TO 0.
lock steering to heading(90,90).
set proginit to true.
sas off.
rcs off.

wait until proginit.

print "Program init is complete. Switching to ground ops.".