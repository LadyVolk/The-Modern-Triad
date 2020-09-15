extends CanvasLayer

signal done

func _ready():
	$Pixel.show()
	$FadeIn.show()

func do_transition():
	
	Global.freeze = true
	
	$Tween.interpolate_property($FadeIn.get_material(), "shader_param/amount", 
								1.0, 0.0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$Pixel/AnimationPlayer.play("PixelEffect")

	yield($Pixel/AnimationPlayer, "animation_finished")
	
	Global.freeze = false

	emit_signal("done")
