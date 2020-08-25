extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grass_on_map = 0
var cut_grass_on_map = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("add_grass", self, "add_grass")
	Signals.connect("cut_grass", self, "cut_grass")
	pass # Replace with function body.

func add_grass():
	grass_on_map += 1
	pass
	
func cut_grass():
	cut_grass_on_map += 1
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func send_result():
	if grass_on_map == cut_grass_on_map:
		Signals.emit_signal("end_level", "finished")
		$AudioStreamPlayer.play()
		$CPUParticles2D.emitting = true
	else:
		Signals.emit_signal("end_level", "unfinished")
	pass

func _on_end_flag_area_entered(area):
	if area.is_in_group("grass_cutter"):
		Signals.emit_signal("stop_movement")
		yield(Signals, "end_move")
		send_result()
	pass # Replace with function body.
