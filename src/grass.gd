tool
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var grass_state = 0

var current_grass_state = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.emit_signal("add_grass")
	$AnimationPlayer.play("grass_mutate")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not grass_state == current_grass_state: 
		current_grass_state = grass_state
		$Sprite.texture = load("res://gfx/grass_" + String(current_grass_state) + ".png")
	pass

func cut_grass():
	$CPUParticles2D.emitting = true
	if grass_state > 0:
		grass_state -= 1
	if grass_state == 0:
		Signals.emit_signal("cut_grass")
	pass
	
func destroy_grass_cutter():
	Signals.emit_signal("stop_movement")
	yield(Signals, "end_move")
	Signals.emit_signal("grass_grow")
	yield(Signals, "grass_has_grown")
	Signals.emit_signal("end_level", "destroy")
	pass

func _on_grass_area_entered(area):
	if area.is_in_group("grass_cutter"):
		if grass_state == 0:
			destroy_grass_cutter()
		else:
			cut_grass()
	pass # Replace with function body.
