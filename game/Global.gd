extends Node

var time
var which_scene: String
var freeze = false
var mode = "transition"

func change_scene(_time, _which_scene: String):
	
	time = _time
	which_scene = _which_scene
	
	if which_scene == "res://Bosses/Depression/Level.tscn":
		mode = "depression"
	elif which_scene == "res://Bosses/Anxiety/Level.tscn":
		mode = "anxiety"
	elif which_scene == "res://Bosses/Self/Level.tscn":
		mode = "self"
	elif which_scene.findn("Corridor") != -1:
		mode = "transition"
	else:
		assert(false, "non valid level: " + str(which_scene))
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Loading.tscn")

