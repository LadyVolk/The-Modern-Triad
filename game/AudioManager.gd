extends Node

var which_stream = 1
var max_sfx = 8


const sfx_paths = {
	"melee_player": preload("res://assets/sounds/melee sound.wav"),
	"damage_boss": preload("res://assets/sounds/damage_boss.wav"),
	"stun_sound": preload("res://assets/sounds/stun_sound.ogg"),
	"speed_boost": preload("res://assets/sounds/speed_boost.wav"),
	"fake_speed_boost": preload("res://assets/sounds/fake_speed_boost.wav"),
	"player_death_1": preload("res://assets/sounds/death_1.ogg"),
	"player_death_2": preload("res://assets/sounds/death_2.ogg"),
	"player_death_3": preload("res://assets/sounds/death_3.ogg"),
	"player_death_4": preload("res://assets/sounds/death_4.ogg")
}

func play_sfx(name, pitch_var = false):
	if not sfx_paths.has(name):
		push_error("sound does not exist:"+str(name))
		assert(false)
	
	var player = get_node("SFXs/AudioStreamPlayer"+str(which_stream))
	which_stream = (which_stream % max_sfx) + 1
	
	player.stream = sfx_paths[name]
	
	if not pitch_var:
		player.pitch_scale = 1
	else:
		randomize()
		player.pitch_scale = rand_range(1-pitch_var, 1+pitch_var)
		
	player.play()
