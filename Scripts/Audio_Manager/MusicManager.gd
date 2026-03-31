class_name Music
extends AudioStreamPlayer

enum MUSICS {
	MENU = 0,
	GAME = 1,
	DANGER = 2,
	END = 3,
}

@export var current_playing:MUSICS
@export var play:MUSICS

var playback: AudioStreamPlaybackInteractive

func _ready() -> void:
	current_playing = MUSICS.MENU
	playback = get_stream_playback()
	if playback:
		playback.switch_to_clip(current_playing)
	else:
		push_error("Music Manager failed to find AudioStreamPlaybackInteractive")	

func _process(_delta: float) -> void:
	if current_playing != play:
		switch_music(play)

func switch_music(music_tag:MUSICS) -> void:
	playback.switch_to_clip(music_tag)
	current_playing = music_tag
