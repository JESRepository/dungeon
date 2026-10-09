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
	_initialize_maze(dimensions)
	_set_outer_wall()
	maze_generated.emit()

func get_maze() -> Array:
	return maze


func _initialize_maze(size: Vector2i):
	for y in size.y:
		maze.append([])
		for x in size.x:
			maze[y].append(Room.new())


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
