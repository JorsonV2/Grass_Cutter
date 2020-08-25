extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal add_grass
signal cut_grass
signal stop_movement
signal end_move
signal end_level(condition)
signal next_level
signal restart_level
signal grass_grow
signal grass_has_grown


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
