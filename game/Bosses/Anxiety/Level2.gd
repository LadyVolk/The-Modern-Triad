extends Node2D


const PROJECTILE = preload("res://PlayerStuff/Projectile.tscn")

onready var player = $Player
onready var boss = $Anxiety

var max_delusions = 2

enum REGION {left, right}

func _ready():
	player.connect("shoot", self, "player_shoot")
	player.connect("update_health", $GameHUD, "update_health")
	player.connect("set_HUD", $GameHUD, "set_HUD")
	player.connect("died", self, "_on_player_died")
	boss.connect("new_target_position", self, "get_boss_position")
	boss.player = player
	##AudioManager.play_bgm("depression")

	Global.freeze = true
	
	$Tween.interpolate_property($Shaders/FadeIn.get_material(), "shader_param/amount", 
								1.0, 0.0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$Shaders/Pixel/AnimationPlayer.play("PixelEffect")


func player_shoot(pos, direction):
	var new_projectile = PROJECTILE.instance()
	$Projectiles.add_child(new_projectile)
	new_projectile.position = pos
	new_projectile.direction = direction
	
	
	
func random_position():
	randomize()
	var shape = $BossArea/CollisionShape2D.shape
	var area = $BossArea.position
	var new_pos = Vector2(rand_range(area.x-shape.extents.x, area.x+shape.extents.x), 
						  rand_range(area.y-shape.extents.y, area.y+shape.extents.y))
	return new_pos
	
func get_boss_position(boss_):
	boss_.target_destination = random_position()
	
	
func _on_player_died():
	player = null
	boss.player = null
	
	$FadeScreen.fade_out()
	
	yield($FadeScreen, "fade_out_finished")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level.tscn")
	
	
func stun_player(stun_time, direction, force):
	if player:
		player.stun(stun_time, direction, force)	


func _on_AnimationPlayer_animation_finished(_anim_name):
	Global.freeze = false
