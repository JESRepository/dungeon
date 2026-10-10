class_name TestMaze
extends TileMapLayer

@export var maze_generator : MazeGenerator

func _ready() -> void:
	if not maze_generator.maze_generated.is_connected(_on_maze_generated):
		maze_generator.maze_generated.connect(_on_maze_generated)

func draw_maze() -> void:
	var maze: Array = maze_generator.get_maze()
	var y_index = 0
	for y : Array in maze:
		var x_index = 0
		for x: Room in y:
			var walls = x.walls
			var tile_index := Vector2i(0,0)
			tile_index = convert_walls_to_index(walls)
			var curr_coords := Vector2i(x_index, y_index)
			set_cell(curr_coords, 0, tile_index)
			x_index += 1
		y_index += 1

func convert_walls_to_index(walls: Dictionary[Room.Direction, bool]) -> Vector2i:
	var wall_binary : Array[int]
	wall_binary.append(int(walls[Room.Direction.NORTH]))
	wall_binary.append(int(walls[Room.Direction.EAST]))
	wall_binary.append(int(walls[Room.Direction.SOUTH]))
	wall_binary.append(int(walls[Room.Direction.WEST]))
	#print(wall_binary)
	wall_binary.reverse()
	var value := 0
	var multiplier = 1
	
	for bit in wall_binary:
		var added_value = bit * multiplier
		value += added_value
		if multiplier == 1:
			multiplier += 1
		else:
			multiplier *= 2
	
	var index := Vector2i(0, 0)
	var new_y = value / 4
	if new_y == 4:
		new_y = 3
	index.y = new_y
	
	var new_x : int
	new_x = value % 4
	index.x = new_x
	
	#print(str(value) + " : " + str(index))
	
	return index
	

func _on_maze_generated() -> void:
	draw_maze()
