extends Node

var time
var which_scene

func change_scene(_time, _which_scene):
	
	time = _time
	which_scene = _which_scene
	
	get_tree().change_scene("res://Loading.tscn")
