extends Node

var time
var which_scene
var freeze = false

func change_scene(_time, _which_scene):
	
	time = _time
	which_scene = _which_scene
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Loading.tscn")

