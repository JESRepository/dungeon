class_name MazeGenerator
extends Node

signal maze_generated

@export var dimensions : Vector2i = Vector2i(1, 1)

var x_max : int
var y_max : int
var maze : Array


func _ready():
	x_max = dimensions.x - 1
	y_max = dimensions.y - 1
	generate_maze()


func generate_maze():
	maze = []
	_initialize_maze(dimensions)
	_fill_all_walls()
	
	var curr_coords : Vector2i = _get_random_cell()
	var visited : Array[Vector2i]
	while visited.size() < (dimensions.x * dimensions.y) - 1:
		var returned_data =  progress_maze(curr_coords, visited)
		curr_coords = returned_data[0]
		visited = returned_data[1]
		#print(visited.size())
	maze_generated.emit()


func progress_maze(maze_coords: Vector2i, visited: Array[Vector2i]) -> Array:
	if not visited.has(maze_coords):
		visited.append(maze_coords)
	var removeable_walls : Array
	## checks which walls are valid to be removed
	if maze_coords.x != 0:
		if not visited.has(Vector2i(maze_coords.x - 1, maze_coords.y)):
			removeable_walls.append(Room.Direction.WEST)
	if maze_coords.x != x_max:
		if not visited.has(Vector2i(maze_coords.x + 1, maze_coords.y)):
			removeable_walls.append(Room.Direction.EAST)
	if maze_coords.y != 0:
		if not visited.has(Vector2i(maze_coords.x, maze_coords.y - 1)):
			removeable_walls.append(Room.Direction.NORTH)
	if maze_coords.y != y_max:
		if not visited.has(Vector2i(maze_coords.x, maze_coords.y + 1)):
			removeable_walls.append(Room.Direction.SOUTH)
	
	## steps back if there is no valid direction
	if removeable_walls.is_empty():
		maze_coords = visited.get(visited.find(maze_coords) - 1)
		return progress_maze(maze_coords, visited)
	## chooses a direction at random
	var move_direction = removeable_walls.pick_random()
	var curr_room : Room = maze[maze_coords.y][maze_coords.x]
	## removes a wall if there is a valid direction
	curr_room.walls.set(move_direction, false)
	
	## moves to the next room
	match move_direction:
		Room.Direction.NORTH:
			#print("moving NORTH")
			maze_coords.y -= 1
		Room.Direction.EAST:
			#print("moving EAST")
			maze_coords.x += 1
		Room.Direction.SOUTH:
			#print("moving SOUTH")
			maze_coords.y += 1
		Room.Direction.WEST:
			#print("moving WEST")
			maze_coords.x -= 1
	
	## sets the current room to the new room
	curr_room = maze[maze_coords.y][maze_coords.x]
	## knocks down the wall from the room we moved from
	match move_direction:
		Room.Direction.NORTH:
			curr_room.walls.set(Room.Direction.SOUTH, 0)
		Room.Direction.EAST:
			curr_room.walls.set(Room.Direction.WEST, 0)
		Room.Direction.SOUTH:
			curr_room.walls.set(Room.Direction.NORTH, 0)
		Room.Direction.WEST:
			curr_room.walls.set(Room.Direction.EAST, 0)
	var data = [maze_coords, visited]
	return data


func get_maze() -> Array:
	return maze


func _initialize_maze(size: Vector2i):
	for y in size.y:
		maze.append([])
		for x in size.x:
			maze[y].append(Room.new())


func _fill_all_walls() -> void:
	for y in maze:
		for x: Room in y:
			x.walls.set(Room.Direction.NORTH, 1)
			x.walls.set(Room.Direction.EAST, 1)
			x.walls.set(Room.Direction.SOUTH, 1)
			x.walls.set(Room.Direction.WEST, 1)


func _set_outer_wall() -> void:
	var x_index = 0
	for x : Array in maze:
		var y_index = 0
		for y : Room in x:
			match y_index:
				0:
					y.walls.set(Room.Direction.WEST, true)
				x_max:
					y.walls.set(Room.Direction.EAST, true)
			match x_index:
				0:
					y.walls.set(Room.Direction.NORTH, true)
				y_max:
					y.walls.set(Room.Direction.SOUTH, true)
			y_index += 1
		x_index += 1


func _get_random_cell() -> Vector2i:
	var cell_coords : Vector2i
	cell_coords.x = randi_range(0, dimensions.x - 1)
	cell_coords.y = randi_range(0, dimensions.y - 1)
	return cell_coords


func _on_button_pressed() -> void:
	generate_maze()
