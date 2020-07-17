extends Control


func _ready():
	AudioManager.play_bgm("menu")


func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level.tscn")


func _on_Quit_pressed():
	get_tree().quit()
