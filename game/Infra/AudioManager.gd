extends Node

var which_stream = 1
var max_sfx = 8

const NORMAL_DB = 0
const MUTE_DB = -60
const FADEIN_SPEED = 60
const FADEOUT_SPEED = 20

const sfx_paths = {
	"melee_player": preload("res://assets/sounds/melee sound.wav"),
	"damage_boss": preload("res://assets/sounds/damage_boss.wav"),
	"stun_sound": preload("res://assets/sounds/stun_sound.ogg"),
	"speed_boost": preload("res://assets/sounds/speed_boost.wav"),
	"fake_speed_boost": preload("res://assets/sounds/fake_speed_boost.wav"),
	"player_death_1": preload("res://assets/sounds/death_1.ogg"),
	"player_death_2": preload("res://assets/sounds/death_2.ogg"),
	"player_death_3": preload("res://assets/sounds/death_3.ogg"),
	"player_death_4": preload("res://assets/sounds/death_4.ogg"),
	"depression_change": preload("res://assets/sounds/depression_change.wav")
	
}
const bgm_paths = {
	"menu": preload("res://assets/sounds/menu_music.ogg"),
	"depression": preload("res://assets/sounds/depression_music.ogg"),
	"corridor": preload("res://assets/sounds/menu_music.ogg")
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


func play_bgm(name):
	if not bgm_paths.has(name):
		push_error("sound does not exist:"+str(name))
		assert(false)
	
	stop_bgm()
	
	var player = get_node("BGMs/FadeIn")
	player.stream = bgm_paths[name]
	player.volume_db = MUTE_DB
	player.play()
	var duration = abs(NORMAL_DB - MUTE_DB)/FADEIN_SPEED
	$BGMs/Tween.interpolate_property(player, "volume_db", MUTE_DB, NORMAL_DB,
									 duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$BGMs/Tween.start()
	
	
	
func stop_bgm():
	if $BGMs/FadeIn.playing:
		$BGMs/FadeOut.stop()
		$BGMs/FadeOut.stream = $BGMs/FadeIn.stream
		$BGMs/FadeOut.volume_db = $BGMs/FadeIn.volume_db
		var music_pos = $BGMs/FadeIn.get_playback_position()
		$BGMs/FadeIn.stop()
		$BGMs/FadeOut.play(music_pos)
		var duration = abs(MUTE_DB - $BGMs/FadeOut.volume_db)/FADEOUT_SPEED
		$BGMs/Tween.interpolate_property($BGMs/FadeOut, "volume_db", $BGMs/FadeOut.volume_db,
										 MUTE_DB, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$BGMs/Tween.start()
	
	
	
	
