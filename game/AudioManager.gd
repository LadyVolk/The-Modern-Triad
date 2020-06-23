extends Node

var which_stream = 1
var max_sfx = 8


const sfx_paths = {
	"melee_player": preload("res://assets/sounds/melee sound.wav")
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
