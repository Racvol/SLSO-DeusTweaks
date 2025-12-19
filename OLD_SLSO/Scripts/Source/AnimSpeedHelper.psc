scriptname AnimSpeedHelper Hidden

; None of these commands save anything to save game, you will need to reuse them
; if game is loaded. All changes are cleared when you reload a game.

; Get version of mod.
int function GetVersion() global native

;/ Set new animation speed for target refr.
target: target refr to set for
scale: time scale of animation speed, 1.0 is normal and 0.5 is 50% speed, negative is now allowed to play animation in reverse
transition: time in seconds until this speed is reached
absolute: time in seconds is fixed or not, if nonzero then it takes exactly this
          many seconds to reach target speed, if zero then it takes
		  speedDiff * transition seconds. Just set 0 if you don't understand :P
		  /;
function SetAnimationSpeed(ObjectReference target, float scale, float transition, bool absolute) global native

;/ Get current animation speed of target refr.
target: target refr to get for
absolute: get the target speed (non-zero) or current speed (zero)
/;
float function GetAnimationSpeed(ObjectReference target, bool absolute) global native

; This refr will stop transitioning animation speed and stay at current speed. If none
; then all refr will do this (all refrs that have been set in SetAnimationSpeed).
function ResetTransition(ObjectReference target) global native

; Gets the name of the last animation event that was sent to refr. Is empty if none were found.
string function GetAnimationEventName(ObjectReference target) global native

;/ Gets the time in seconds that has passed since last animation event was received. This time
is modified by our scalers and may be negative due to this! /;
float function GetAnimationEventElapsed(ObjectReference target) global native

; Warps animation forward or backwards by X seconds.
function WarpAnimation(ObjectReference target, float amount) global native

; Reset and remove all animation overwrites.
function ResetAll() global native
