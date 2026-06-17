// https://love2d.org/wiki/Config_Files

// prettier-ignore
love.conf = (t) => {
	t.version			= "11.5"	// Target LÖVE version (change to match yours)
	t.console			= false		// Set true on Windows to see print() output

	t.window.title		= "Itsukai"
	t.window.width		= 816
	t.window.height		= 624
	t.window.resizable	= true
	t.window.vsync		= 1			// 1 = on, 0 = off
	
	// Disable modules you don't use for a cleaner startup
	// t.modules.joystick  = false
	// t.modules.touch     = false
	// t.modules.video     = false
}
