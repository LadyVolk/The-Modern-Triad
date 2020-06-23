extends Node

var which_stream = 1
var max_sfx = 8


const sfx_paths = {
	"melee_player": preload("res://assets/sounds/melee sound.wav")
}

func play_sfx(name):
	var player = get_node("SFXs/AudioStreamPlayer"+str(which_stream))

	which_stream = (which_stream % max_sfx) + 1
	
	player.stream = sfx_paths[name]
	
	player.play()
