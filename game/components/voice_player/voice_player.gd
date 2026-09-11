class_name VoicePlayer
extends AudioStreamPlayer

func _ready() -> void:
	if !finished.is_connected(_on_finished):
		finished.connect(_on_finished.bind())

var active := false

func start() -> void:
	active = true
	play()


func stop_playback() -> void:
	active = false


func _on_finished() -> void:
	if active:
		play()
