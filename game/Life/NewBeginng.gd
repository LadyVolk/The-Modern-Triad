extends Control

func _ready():
	
	$TransitionShader.do_transition()
	
	yield($TransitionShader, "done")
	
	yield(get_tree().create_timer(3), "timeout")
	
	$Tween.interpolate_property($VBoxContainer, "rect_position", \
								$VBoxContainer.rect_position, \
								Vector2($VBoxContainer.rect_position.x, -2000),\
								15, Tween.TRANS_LINEAR, Tween.EASE_IN) 
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	get_tree().quit()
