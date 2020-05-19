extends CanvasLayer


func _ready():
	pass
	
func update_health(health):
	$ProgressBar.value = health
