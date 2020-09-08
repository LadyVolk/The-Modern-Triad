extends Node2D

func _ready():
	
	$Tween.interpolate_property($Shaders/FadeIn.get_material(), "shader_param/amount", 
								1.0, 0.0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$Shaders/Pixel/AnimationPlayer.play("PixelEffect")

