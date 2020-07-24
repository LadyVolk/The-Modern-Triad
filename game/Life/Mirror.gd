extends Node2D


func _ready():
	pass 


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Bosses/Depression/Level.tscn")
