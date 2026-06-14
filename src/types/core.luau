local E = require('./engine')


local Core = {}

export type LoveAudio = E.Object & {
	_path: string;
	Path: string;
	_volume: number;
	Volume: number;
	_pitch: number;
	Pitch: number;
	_pan: number;
	Pan: number;

	_source: Source?;
	_stopListeners: {() -> ()};
	_isError: boolean;
	_fadeTarget: number;
	_fadeFrom: number;
	_fadeDuration: number;
	_fadeElapsed: number;

	new: (string, boolean?) -> LoveAudio;
	IsReady: (LoveAudio) -> boolean;
	IsError: (LoveAudio) -> boolean;
	IsPlaying: (LoveAudio) -> boolean;
	Play: (LoveAudio, boolean?, number?) -> ();
	Stop: (LoveAudio) -> ();
	Pause: (LoveAudio) -> ();
	Destroy: (LoveAudio) -> ();
	FadeIn: (LoveAudio, number) -> ();
	FadeOut: (LoveAudio, number) -> ();
	Clear: (LoveAudio) -> ();
	Update: (LoveAudio, number) -> ();
	Seek: (LoveAudio) -> number;
	AddStopListener: (LoveAudio, ()->()) -> ();

	_load: (LoveAudio, boolean?) -> ()
}

export type Stage = E.GameObject & {
	new: () -> Stage;
	Destroy: (Stage) -> ();
}

return Core