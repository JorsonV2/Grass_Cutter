extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var move_speed : float = 1.5
export (Texture) var sprite_right
export (Texture) var sprite_left
export (Texture) var sprite_up
export (Texture) var sprite_down

var is_moving = false
var stoped = false
var stop_movement = false

var move_distance = 56

var move_direction = Vector2(0,0)
var move_start_position = Vector2(0,0)
var move_end_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("stop_movement", self, "stop_movement")
	Signals.connect("grass_grow", self, "grass_grow")
	Signals.connect("end_level", self, "end_level")
	$AnimationPlayer.play("basic")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	if not stoped:
		if !is_moving and move_direction != Vector2(0,0):
			start_move()
		if is_moving:
			move(delta)
	pass
	
func get_input():
	if Input.is_action_pressed("down"):
		move_direction = Vector2.DOWN
	elif Input.is_action_pressed("left"):
		move_direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		move_direction = Vector2.RIGHT
	elif Input.is_action_pressed("up"):
		move_direction = Vector2.UP
	pass
	
func start_move():
	is_moving = true
	move_start_position = global_position
	move_end_position = global_position + (move_direction * move_distance)
	if move_direction == Vector2.RIGHT:
		$Sprite.texture = sprite_right
	elif move_direction == Vector2.LEFT:
		$Sprite.texture = sprite_left
	elif move_direction == Vector2.UP:
		$Sprite.texture = sprite_up
	elif move_direction == Vector2.DOWN:
		$Sprite.texture = sprite_down
	pass
	
var f = 0	
	
func move(delta):
	if f >= 1:
		end_move()
	else:
		global_position = global_position.linear_interpolate(move_end_position, f)
		f += delta * move_speed
	pass
	
func end_move():
	is_moving = false
	f = 0
	if stop_movement:
		stop_move()
	Signals.emit_signal("end_move")
	pass
	
func stop_move():
	$grass_cutter_sound_fade.play("fade")
	move_direction = Vector2.ZERO
	stoped = true
	pass
	
func stop_movement():
	stop_movement = true
	pass
	
func grass_grow():
	$AnimatedSprite.play("grass_grow")
	$grass_grow_sound.play()
	yield($AnimatedSprite, "animation_finished")
	Signals.emit_signal("grass_has_grown")
	pass
	
func end_level(condition):
	$AnimationPlayer.stop()
	pass

func _on_grass_cutter_body_entered(body):
	if body.is_in_group("border"):
		Signals.emit_signal("end_level", "crashed")
		$CPUParticles2D.emitting = true
		$crash_sound.play()
		stop_move()
	pass # Replace with function body.
