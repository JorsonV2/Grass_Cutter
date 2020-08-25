extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levels = 0
var level = 1

var deads = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("end_level", self, "end_level")
	get_levels()
	$button_const_animation.play("buttons")
	pass # Replace with function body.
	
func get_levels():
	var dir = Directory.new()
	dir.open("res://scenes/levels")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			levels += 1
	
	dir.list_dir_end()
	pass

func end_level(condition):
	print_debug(condition)
	match condition:
		"finished":
			message("Nice work GRASS CUTTER " + String(2000 + deads) + " Keap it up!")
			$button_animation.play("fade_next")
		_:
			print_debug("restart")
			match condition:
				"unfinished":
					message("You need to cut all of the grass!")
				"crashed":
					message("We need to calibrate the movement")
				"destroy":
					message("That cursed grass is really agressive")
			$button_animation.play("fade_restart")
	pass
	
func message(text):
	find_node("message").text = text
	$message_animation.play("fade")
	pass
	
func next_level():
	if level == levels:
		$fade_animation.play("fade_end")
	else:
		level += 1
		$button_animation.play_backwards("fade_next")
		change_level()
	pass
	
func restart_level():
	deads += 1
	$button_animation.play_backwards("fade_restart")
	change_level()
	pass
	
func change_level():
	$message_animation.play_backwards("fade")
	$fade_animation.play("fade")
	yield($fade_animation, "animation_finished")
	get_node("level").queue_free()
	yield(get_node("level"), "tree_exited")
	$fade_animation.play_backwards("fade")
	var level_map = load("res://scenes/levels/level_" + String(level) + ".tscn")
	add_child(level_map.instance())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
