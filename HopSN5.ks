CLEARSCREEN.
PRINT "SN5 Hop Program loaded.".
WAIT 1.
PRINT "Program init in progress.".

// Variables
SET Tplus TO 0.
SET countdown TO 10.
SET timerRunning TO FALSE.
SET hold TO FALSE.
SET reset TO FALSE.
SET abortProgram TO FALSE. // Flag to indicate program abort

// Initialization
LOCK THROTTLE TO 0.
LOCK STEERING TO HEADING(0,0).
SAS OFF.
RCS OFF.

// Functions Init

FUNCTION logCountdown {
    LOCAL countdownlogpath IS "0:/logfiles/countdown_log.txt".
    DELETEPATH(countdownlogpath).
    LOCAL logString IS "".
    IF countdown > 0 {
        SET logString TO "T-" + countdown.
    } ELSE {
        SET logString TO "T+" + Tplus.
    }
    LOG logString TO countdownlogpath.
}

WAIT 1.

PRINT "Program init is complete. Switching to ground ops.".

// GUI Creation
LOCAL my_gui IS GUI(200).
LOCAL startButton IS my_gui:ADDBUTTON("Start Countdown").
LOCAL holdButton IS my_gui:ADDBUTTON("Hold").
LOCAL resetButton IS my_gui:ADDBUTTON("Reset").
LOCAL abortButton IS my_gui:ADDBUTTON("Abort Program"). // Abort button
LOCAL countdownInput IS my_gui:ADDTEXTFIELD(countdown:tostring).
LOCAL setCountButton IS my_gui:ADDBUTTON("Set Count").
LOCAL countdownLabel IS my_gui:ADDLABEL("Countdown: " + "T-" + countdown).

my_gui:SHOW().

// GUI Callbacks
FUNCTION onStartClick {
  SET countdown TO countdownInput:TEXT:TONUMBER().
  SET timerRunning TO TRUE.
  SET hold TO FALSE.
  SET reset TO FALSE.
  PRINT "Countdown started with " + countdown + " seconds.".
}
SET startButton:ONCLICK TO onStartClick@.

FUNCTION onHoldClick {
  SET hold TO NOT hold.
  PRINT "Count hold: " + hold:TOSTRING().
}
SET holdButton:ONCLICK TO onHoldClick@.

FUNCTION onResetClick {
  SET reset TO TRUE.
  PRINT "Countdown reset initiated.".
}
SET resetButton:ONCLICK TO onResetClick@.

FUNCTION onAbortClick {
  SET abortProgram TO TRUE. // Set the abort flag
  PRINT "Program abort initiated.".
}
SET abortButton:ONCLICK TO onAbortClick@.

FUNCTION onSetCountClick {
  LOCAL newCountdown IS countdownInput:TEXT:TONUMBER().
  IF newCountdown >= 0 {
    SET countdown TO newCountdown.
    SET countdownLabel:TEXT TO "Countdown: T-" + countdown. // Update label
    PRINT "Countdown set to " + countdown + " seconds.".
  } ELSE {
    PRINT "Invalid countdown value entered.".
  }
}
SET setCountButton:ONCLICK TO onSetCountClick@.

// Timer Management
UNTIL abortProgram {
  IF timerRunning AND NOT hold {
    IF countdown > 1 {
      PRINT "T-" + countdown.
      SET countdownLabel:TEXT TO "Countdown: T-" + countdown.
      SET countdown TO countdown - 1.
    } ELSE IF countdown = 1 {
      PRINT "T-" + countdown.
      SET countdownLabel:TEXT TO "Countdown: T-" + countdown.
      WAIT 0.5. // Half second at T-1
      PRINT "T-0".
      SET countdownLabel:TEXT TO "Countdown: T-0".
      WAIT 0.5. // Half second at T-0
      SET countdown TO countdown - 1.
      PRINT "T+0".
      SET countdownLabel:TEXT TO "Time Elapsed: T+0".
      WAIT 1. // Normal second at T+0 before starting countup
    } ELSE {
      SET Tplus TO Tplus + 1.
      PRINT "T+" + Tplus.
      SET countdownLabel:TEXT TO "Time Elapsed: T+" + Tplus.
    }
  } ELSE IF reset {
    SET Tplus TO 0.
    SET countdown TO 10.
    SET timerRunning TO FALSE.
    SET reset TO FALSE.
    SET countdownInput:TEXT TO "10".
    SET countdownLabel:TEXT TO "Countdown: " + countdown.
  }
  WAIT 1.
  logCountdown().
}

// When the abort flag is set, hide and dispose the GUI
my_gui:HIDE().
my_gui:DISPOSE().
PRINT "Program aborted.".