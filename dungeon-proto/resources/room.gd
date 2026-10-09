class_name Room
extends Resource

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

@export var walls : Dictionary[Direction, bool] = {
	Direction.NORTH : false,
	Direction.EAST : false,
	Direction.SOUTH : false,
	Direction.WEST : false,
}
