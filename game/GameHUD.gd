extends CanvasLayer

func _ready():
	pass
	
func update_health(health):
	$ProgressBar.value = health

func set_HUD(max_health):
	$ProgressBar.max_value = max_health
	$ProgressBar.value = max_health
