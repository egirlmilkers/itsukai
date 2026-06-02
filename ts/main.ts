import { KeyConstant } from "love.keyboard"


/*=========================
------ LÖVE Callbacks -----
=========================*/

// This function gets called only once when the game is started
love.load = () => {
	//
}

love.update = (dt: number) => {
	//
}

love.draw = () => {
	//
}

love.mousepressed = (x: number, y: number, button: number, isTouch: boolean) => {
	//
}

love.keypressed = (key: KeyConstant) => {
	//
}

love.keyreleased = (key: KeyConstant) => {
	//
}

// Called whenever the user clicks off and on the LÖVE window
love.focus = (inFocus: boolean) => {
	//
}

// Callback function triggered by the default love.run when the game is closed
// Return true to prevent the game from actually quitting
love.quit = () => {
	if (false) {
		print("We are not ready to quit yet!")
		return true
	} else {
		print("Thanks for playing. Please play again soon!")
		return false
	}
}