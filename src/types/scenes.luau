local C = require('core')


local Scenes = {}

export type Base = C.Stage & {
	_started: boolean;
	_active: boolean;
	_fadeSign: number;
	_fadeDuration: number;
	_fadeWhite: number;
	_fadeOpacity: number;

	new: () -> Base;
	Create: (Base) -> ();
	IsActive: (Base) -> boolean;
	Start: (Base) -> ();
	Update: (Base, number) -> ();
	Stop: (Base) -> ();
	Terminate: (Base) -> ();
	IsStarted: (Base) -> boolean;
	IsBusy: (Base) -> boolean;
	IsFading: (Base) -> boolean;
	UpdateFade: (Base) -> ();
	UpdateChildren: (Base) -> ();
}

return Scenes