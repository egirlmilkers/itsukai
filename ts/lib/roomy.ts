/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright © 2026 EGirlMilkers (SoniaNvm)
 * 
 * ------------------------------------------------------------------
 * This file contains a TypeScript translation of "Roomy". The under-
 * lying logic and original Lua implementation are licensed under
 * the MIT License:
 *
 * MIT License
 *
 * Copyright (c) 2019 Andrew Minnich
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * A Scene is any object whose methods map to LÖVE callbacks and the four
 * roomy lifecycle events: start, end, pause, resume.
 *
 * The index signature is required so the Manager can dispatch any arbitrary
 * LÖVE callback by name without sacrificing type safety on the lifecycle hooks.
 */
export interface Scene {
	/** Called after this scene becomes the active scene. */
	start?(previous: Scene | undefined, ...args: unknown[]): void
	/** Called just before this scene is replaced or popped. */
	end?(next: Scene | undefined, ...args: unknown[]): void
	/** Called when a new scene is pushed on top of this one. */
	pause?(next: Scene, ...args: unknown[]): void
	/** Called when the scene above this one is popped. */
	resume?(previous: Scene, ...args: unknown[]): void
}

type SceneTable = Record<string, ((...args: unknown[]) => unknown) | undefined>;

/** Every LÖVE callback that roomy will forward to the active scene by default. */
const LOVE_CALLBACKS: string[] = [
	'displayrotated',
	'directorydropped',
	'draw',
	'errorhandler',
	'filedropped',
	'focus',
	'gamepadaxis',
	'gamepadpressed',
	'gamepadreleased',
	'joystickadded',
	'joystickaxis',
	'joystickhat',
	'joystickpressed',
	'joystickreleased',
	'joystickremoved',
	'keypressed',
	'keyreleased',
	'load',
	'lowmemory',
	'mousefocus',
	'mousemoved',
	'mousepressed',
	'mousereleased',
	'quit',
	'resize',
	'run',
	'textedited',
	'textinput',
	'threaderror',
	'touchmoved',
	'touchpressed',
	'touchreleased',
	'update',
	'visible',
	'wheelmoved',
]

/** Options accepted by {@link Manager.hook}. */
export interface HookOptions {
	/** If provided, only hook these callbacks instead of the full default list. */
	include?: string[]
	/** Callbacks to skip when hooking. Applied after `include`. */
	exclude?: string[]
}

/**
 * The scene manager. Create and call {@link hook} once
 * in `love.load` to wire it into LÖVE's event loop.
 */
export class Manager {
	/** Stack of scenes; the last element is always the active scene. */
	private readonly stack: Scene[] = [{}]

	private get active(): Scene {
		return this.stack[this.stack.length - 1]
	}

	/**
	 * Fire `event` on the currently active scene, passing any extra arguments.
	 * Silently does nothing if the active scene has no such handler.
	 */
	private emit(event: string, ...args: unknown[]): void {
		const scene = this.active as SceneTable
		scene[event]?.call(scene, ...args)
	}

	/**
	 * Replace the active scene with `next`.
	 * Fires `end` on the current scene then `start` on `next`.
	 */
	goto(next: Scene, ...args: unknown[]): void {
		const previous = this.active
		this.emit('end', next, ...args)
		this.stack[this.stack.length - 1] = next
		this.emit('start', previous, ...args)
	}

	/**
	 * Push `next` onto the stack without removing the current scene.
	 * Fires `pause` on the current scene then `start` on `next`.
	 */
	push(next: Scene, ...args: unknown[]): void {
		const previous = this.active
		this.emit('pause', next, ...args)
		this.stack.push(next)
		this.emit('start', previous, ...args)
	}

	/**
	 * Pop the active scene off the stack, returning to the one beneath it.
	 * Fires `end` on the removed scene then `resume` on the scene below.
	 */
	pop(...args: unknown[]): void {
		const previous = this.active
		this.emit('end', this.stack[this.stack.length - 2], ...args)
		this.stack.pop()
		this.emit('resume', previous, ...args)
	}

	/**
	 * Wrap every listed LÖVE callback so the manager automatically forwards
	 * events to the active scene. Call once in `love.load`.
	 *
	 * Any callback that already exists on the `love` table is preserved and
	 * called first, so you can still define top-level `love.*` handlers.
	 */
	hook(options?: HookOptions): void {
		const excluded = new Set(options?.exclude)
		const callbacks = (options?.include ?? LOVE_CALLBACKS).filter(
			(cb) => !excluded.has(cb),
		)

		const loveTable = love as unknown as Record<
			string,
			((...args: unknown[]) => unknown) | undefined
		>

		for (const name of callbacks) {
			const existing = loveTable[name]
			loveTable[name] = (...args: unknown[]) => {
				existing?.(...args)
				this.emit(name, ...args)
			}
		}
	}
}
