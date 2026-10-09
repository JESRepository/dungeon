class_name MazeGenerator
extends Node

signal maze_generated

@export var dimensions : Vector2i = Vector2i(7, 7)

var x_max = dimensions.x - 1
var y_max = dimensions.y - 1
var maze : Array

func _ready():
	generate_maze()

func generate_maze():
	_initialize_maze(dimensions)
	_set_outer_wall()
	maze_generated.emit()
	print("generated")

func get_maze() -> Array:
	return maze


func _initialize_maze(size: Vector2i):
	for x in size.x:
		maze.append([])
		for y in size.y:
			maze[x].append(Room.new())


func _set_outer_wall() -> void:
	var x_index = 0
	for x : Array in maze:
		var y_index = 0
		for y : Room in x:
			match y_index:
				0:
					y.walls.set(Room.Direction.WEST, true)
				y_max:
					y.walls.set(Room.Direction.EAST, true)
			match x_index:
				0:
					y.walls.set(Room.Direction.NORTH, true)
				x_max:
					y.walls.set(Room.Direction.SOUTH, true)
			y_index += 1
		x_index += 1
