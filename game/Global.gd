extends Node

var time
var which_scene
var freeze = false
var mode

func change_scene(_time, _which_scene):
	
	time = _time
	which_scene = _which_scene
	
	if which_scene == "res://Bosses/Depression/Level.tscn":
		mode = "depression"
	elif which_scene == "res://Bosses/Anxiety/Level2.tscn":
		mode = "anxiety"
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Loading.tscn")

