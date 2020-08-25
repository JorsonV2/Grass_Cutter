extends Area2D

class_name movable

export var move_value = 14
export var move_speed : float = 3
export var move_direction = Vector2(0, 0)

var moved = false
var moving_back = false
var is_moving = false

var move_destination = Vector2(0, 0)
var move_start_position = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("movable")
	connect("area_entered", self, "_area_entered")
	pass # Replace with function body.
	
func _process(delta):
	if is_moving:
		move(delta)
	pass
	
func set_move(_x, _y):
	is_moving = true
	move_direction = Vector2(_x, _y)
#	move_destination = (global_position + (move_direction * move_value)).floor()
	var x = global_position.x + (move_direction.x * move_value)
	var y = global_position.y + (move_direction.y * move_value)
	
	var x_fix = int(x + 7) / int(14) * int(14)
	var y_fix = int(y + 7) / int(14) * int(14)
	
#	if x - 0.5 > floor(x):
#		x = floor(x) + 1
#	else:
#		x = floor(x)
#
#	if y - 0.5 > floor(y):
#		y = floor(y) + 1
#	else:
#		y = floor(y)
		
#	move_destination = Vector2(stepify(x, 1), stepify(y, 1))
	move_destination = Vector2(x_fix, y_fix)
	move_start_position = Vector2(stepify(global_position.x, 1), stepify(global_position.y, 1))
	t = 0
	pass

var t = 0

func end_move():
	is_moving = false
	t = 0
	moved = false
	global_position = move_destination
	moving_back = false
	move_direction = Vector2(0,0)
	pass

func move(delta):
	if t >= 1:
		end_move()
		return
	if moved:
		for area in get_overlapping_areas():
			if area.is_in_group("movable"):
				if area.move_direction != move_direction and global_position.direction_to(area.global_position) == move_direction:
					if moving_back and area.is_moving:
						area.move_back(move_destination)
					else:
						area.set_move(move_direction.x, move_direction.y)
					moved = false
	t += delta * move_speed
	global_position = move_start_position.linear_interpolate(move_destination, t)
	pass
	
func move_back(object_global_position):
	
	set_move(-move_direction.x, -move_direction.y)
	var x = object_global_position.x + (move_direction.x * move_value)
	var y = object_global_position.y + (move_direction.y * move_value)
#	var x = move_destination.x + (move_direction.x * move_value)
#	var y = move_destination.y + (move_direction.y * move_value)
	move_destination = Vector2(stepify(x, 1), stepify(y, 1))
	moving_back = true
	moved = true
	
	t = 0
	pass
	
func _area_entered(area : movable):
	if area != null:
		if area.is_in_group("movable"):
			if !area.moved and is_moving:
				if area.is_in_group("cant_move"):
					move_back(area.global_position)
				else:
					area.set_move(move_direction.x, move_direction.y)
					area.moved = true
					area.t = 0
	pass
