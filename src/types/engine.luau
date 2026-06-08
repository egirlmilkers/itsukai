local Engine = {}

export type Object = {
	ClassName: string;

	new: () -> Object;
	IsA: (Object, string) -> boolean;
	Clone: (Object) -> Object;

	_deepCopy: (any) -> any;
}

export type GameObject = Object & {
	_destroyed: boolean;

	Children: {any};
	Parent: any?;
	X: number;
	Y: number;
	Rotation: number;
	ScaleX: number;
	ScaleY: number;
	PivotX: number;
	PivotY: number;
	Visible: boolean;
	Alpha: number;

	new: () -> GameObject;
	AddChild: (GameObject, child: any) -> any;
	AddChildAt: (GameObject, child: any, index: number) -> any;
	RemoveChild: (GameObject, child: any) -> any;
	RemoveChildAt: (GameObject, index: number) -> any;
	RemoveChildren: (GameObject) -> {any};
	RemoveFromParent: (GameObject) -> ();
	UpdateTransform: (GameObject) -> ();
	Draw: (GameObject) -> ();
	Destroy: (GameObject, boolean) -> ();
}

return Engine