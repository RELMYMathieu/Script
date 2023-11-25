// Variables
LOCAL targetAltitude IS 150.
LOCAL targetTWR IS 1.07.
LOCAL ar IS ALT:RADAR.
LOCK grav TO body:mu / body:postion:sqrmagnitude.

// Function to calculate current TWR
FUNCTION currentTWR {
    RETURN SHIP:AVAILABLETHRUST / (SHIP:MASS * grav).
}

// Main ascent loop
WHEN ar < targetAltitude THEN {
    // Calculate the necessary throttle setting
    LOCAL newThrottleSetting IS targetTWR / currentTWR().

    // Adjust throttle
    LOCK THROTTLE TO newThrottleSetting.

    // Print current TWR and Throttle setting
    PRINT "Current TWR: " + ROUND(currentTWR(), 2) + " Throttle Setting: " + ROUND(newThrottleSetting * 100, 0) + "%".

    PRESERVE.
}

// Cut engines when target altitude is reached
WAIT UNTIL ar >= targetAltitude.
LOCK THROTTLE TO 0.
PRINT "Ascent complete. Engines off.".