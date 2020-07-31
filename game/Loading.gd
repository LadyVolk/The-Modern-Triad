extends Node2D


func _ready():
	yield(get_tree().create_timer(Global.time), "timeout")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene(Global.which_scene) 

