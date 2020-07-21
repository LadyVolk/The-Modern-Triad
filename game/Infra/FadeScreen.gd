extends CanvasLayer

signal fade_out_finished

func _ready():
	pass 


func fade_out():
	$Tween.interpolate_property($ColorRect, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 
								3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

	yield($Tween, "tween_completed")
	
	emit_signal("fade_out_finished")
