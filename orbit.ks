//orbit.ks
//This script launches a ship from KSC and puts it into orbit around Kerbin.

clearscreen.

SAS off.
RCS on.
lights on.
lock throttle to 0.
gear off.

set minApoapsis to 245000.
set maxApoapsis to 255000.
set minPerapsis to 245000.
set maxPerapsis to 255000.

set runmode to 2.
if(ALT:RADAR < 100) {
    set runmode to 1.
}

until(runmode = 0) { 
    if(runmode = 1) {
        lock steering to UP.
        set TVAL to 1.
        stage.
        set runmode to 2.
    }

    else if(runmode = 2) {
        lock steering to heading(90,90).
        set TVAL to 1.
        if(SHIP:ALTITUDE > 7000) {
            set runmode to 3.
        }
    }

    else if(runmode = 3) { //Gravity turn
        set targetPitch to max(5, 90 * (1 - ALT:RADAR / 50000)).
        lock steering to heading(90, targetPitch).
        set TVAL to 1.

        if(SHIP:APOAPSIS > minApo) {
            set runmode to 4.
        }
    }

    else if(runmode = 4) {
        lock steering to heading(90, 3).
        set TVAL to 0.
        if((SHIP:ALTITUDE > 70000) and (ETA:APOAPSIS > 60) and (VERTICALSPEED > 0)) {
            if(WARP = 0) {
                wait 1.
                SET WARP TO 3.
            }
        }
        else if(ETA:APOAPSIS < 60) {
            SET WARP to 0.
            set runmode to 5.
        }
    }

    else if(runmode = 5) {
        if((ETA:APOAPSIS < 5) or (VERTICALSPEED < 0)) { 
            set TVAL to 1.
        }
        if((SHIP:PERIAPSIS > minPer) or (SHIP:PERIAPSIS > minApo)) {
            set TVAL to 0.
            set runmode to 11.
        }
    }

    else if(runmode = 10) {
        if((SHIP:PERIAPSIS > minPeriapsis) and (SHIP:APOAPSIS > minApoapsis)) {
            if(ETA:PERIAPSIS < ETA:APOAPSIS) {
            }
        }
    }

     else if(runmode = 11) {
        set TVAL to 0.
        panels on.
        lights on.
        unlock steering.
        print "Target orbit reached. Shutting off.".
        set runmode to 0.
    }

    if((stage:Liquidfuel < 1) or (stage:Solidfuel < 1)) {
        lock throttle to 0.
        wait 1.
        stage.
        wait 2.
        lock throttle to TVAL.
    }

    set finalTVAL to TVAL.
    lock throttle to finalTVAL.
}
