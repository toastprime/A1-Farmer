#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;*****************************
;Settings 
;*****************************
Global gemLvl := 9 				;Starting trap/tower/lantern gem level. Amps start at 3 levels below this value

Global manaTrapPriority := 6    	;
Global killTrapPriority := 3		; 0: Nearest, 1: Swarmlings , 2: Giants, 3: Random
Global killTowerPriority := 5		; 4: Structure (Tower) - Least Affected by Gem (Lantern/Trap)
Global slowLanternPriority := 6		; 5: Special/Orb/Banish, 6: Shield/Armor, 7: Least HP
Global bleedLanternPriority := 4	; 

Global runs := 4					;Number of runs

Global spellX := 190				;x coordinate for spells
Global spellY := 205				;y coordinate for spells


;*****************************
;Layout Coordinates - Use AutoHotKey Window Spy ingame to modify locations
;*****************************
Global manatrapAmps := [Array(109, 148), Array(165, 148), Array(220, 148), Array(109, 260)
					, Array(165, 260), Array(220, 260), Array(275, 148), Array(275, 260)]
Global bleedAmps := [Array(270, 320), Array(270, 370), Array(330, 371), Array(385,317)]
Global killtrapAmps := [Array(330, 148), Array(385, 148), Array(440, 148), Array(330, 260)
					, Array(385, 260), Array(440, 260)]
			
Global killtowerAmps := [Array(918,345), Array(918,285), Array(980,345), Array(1030,345), Array(1030,285)]

Global slowlanternAmps := [Array(107,317), Array(161,368), Array(218,320), Array(218,379)]

Global manatraps := [Array(109, 210), Array(165, 210), Array(220, 210), Array(275, 210)]
Global bleedLanterns := [Array(330, 320)]
Global killtraps := [Array(330, 210), Array(385, 210), Array(440, 210)]
			
Global killtowers := [Array(975,290)]	
Global slowlanterns := [Array(163,318)]

;killswitch
Esc::ExitApp

;build-only hotkey
^b::
	Build()		
return

;Run game on auto
^r::
	RunGame()
return

;****************
;Functions
;****************

Build()
{
	SetNumLockState, 1
	Loop % gemLvl - 4 
	{ 	;set gem Lvl for amps, 3 less than tower
		Click, WU
		Sleep, 100
	}
	
	Send a					;build Amps
	for k, v in manatrapAmps
	{				
		x := v[1], y := v[2]
		Click %x%, %y%
		Send a
		Send {Numpad5}
		Click %x%, %y%
		Send a
	}
	for k, v in bleedAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send a
		Send {Numpad6}
		Click %x%, %y%
		Send a
	}
	for k, v in killtrapAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send a
		Send {Numpad4}
		Click %x%, %y%
		Send a
	}
	for k, v in killtowerAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send a
		Send {Numpad4}
		Click %x%, %y%
		Send a
	}
	for k, v in slowLanternAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send a
		Send {Numpad3}
		Click %x%, %y%
		Send a
	}
	
	Send a
	Loop % 3 {
		Click, 0, 0
		Click, WU
	}
	Send r
						;build Traps
	for k, v in manatraps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send r
		Send {Numpad5}
		Click %x%, %y%
		Loop % manaTrapPriority
			Click, right
		Send r
	}
	for k, v in killtraps
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send r
		Send {Numpad4}
		Click %x%, %y%
		Loop % killTrapPriority
			Click, right
		Send r
	}
	
	Send t					;build Towers
	for k, v in killtowers
	{
		x := v[1]
		y := v[2]
		Click %x%, %y%
		Send t
		Send {Numpad4}
		Click %x%, %y%
		Loop % killTowerPriority
			Click, right
		Send t
	}
	
	Send l					;build Lanterns
	for k, v in slowlanterns
	{
		x := v[1]
		y := v[2]
		Click %x%, %y%
		Send l
		Send {Numpad3}
		Click %x%, %y%
		Loop % slowLanternPriority
			Click, right
		Send l
	}
	for k, v in bleedLanterns
	{
		x := v[1], y := v[2]
		Click %x%, %y%
		Send l
		Send {Numpad6}
		Click %x%, %y%
		Loop % bleedLanternPriority
			Click, right
		Send l
	}
	Send l
	SetNumLockState, 0
	Click, 0, 0
	return
}


UpgradeMana(times)
{	

	for k, v in manatraps
	{				
		x := v[1], y := v[2]
		Click %x%, %y%, 0 
		Loop % times
			Send u
		Random, rand, , 9
		if (rand > 4)
			Send 5
	}

	for k, v in manatrapAmps
	{				
		x := v[1], y := v[2]
		Click %x%, %y%, 0 
		Loop % times
			Send u
	}
	
	Click, 0, 0
	return
}

UpgradeKill(times)
{

	for k, v in killtraps
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
		Random, rand, , 9
		if (rand > 4)
			Send 6
	}
	for k, v in killtowers
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
	}

	for k, v in killtrapAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
	}
	for k, v in killtowerAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
	}

	Click, 0, 0
	return
}


UpgradeUtility(times)
{

	for k, v in bleedLanterns
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
		Send 4
	}
	for k, v in slowlanterns
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
		Send 4
	}

	for k, v in slowLanternAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
	}
	for k, v in bleedAmps
	{
		x := v[1], y := v[2]
		Click %x%, %y%, 0
		Loop % times
			Send u
	}
	Click, 0, 0
	return	
}

RunGame()
{

	
	Loop % runs	
	{
		Click, 993, 566
		Click, 948, 562
		Sleep 2000
		MouseClick, left, 1440, 900
		Sleep 12000
		Build()
		
		Send q
		Send q
		loopCount := 1
		Sleep 15000
		Send q
		
		Loop													;main loop
		{
			
			UpgradeKill(1)
			PixelGetColor, color, 802, 82
			if (color == 0x89DDE9)
				break	
				
			if (loopCount == 8)
				Send q	
				
			if (loopCount > 12)
			{
				Send nn
				Sleep 2000
				if(loopcount > 16)
				{
					Send n
					Sleep 3000
					Send n
				}
			}
				
			if (loopcount < 15)
			{
				UpgradeUtility(1)
			}
			
			Sleep 3000
			UpgradeMana(2)
			PixelGetColor, color, 802, 82
			if (color == 0x89DDE9)
				break
			Sleep 1000
			
			Send 1
			Click, %spellX%, %spellY%
			Send 2
			Click, %spellX%, %spellY%
			
			loopCount++
		}
		
		Sleep 300
		Click, 1750, 975	
		Sleep 10000
	}
	return
}

