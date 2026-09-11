class_name DialogController
extends Node

# parent node
@export var character: PopochiuCharacter
# optional, plays audio along with dialog
@export var voice_player: VoicePlayer
# defines prefix for character animations when not in dialog
@export var inital_animation_prefix: String = "default"


# call from _on_room_set() function in character
func _on_room_set() -> void:
	var dialog_component = G.gui.get_component("DialogPortrait")
	if !dialog_component.waiting_input.is_connected(_on_dialog_waiting_input):
		dialog_component.waiting_input.connect(_on_dialog_waiting_input.bind())


# ends audio playback and talking animation when ready for player input to progress dialog
func _on_dialog_waiting_input() -> void:
	voice_player.stop_playback()
	character._play_idle()


# plays voice audio for character, and sets prefix for talking/idle animation if passed in
func say(text: String, prefix: String = "") -> void:
	if character == null:
		return
		
	if voice_player != null:
		voice_player.start()
		
	character.set_animation_prefix(prefix)
	await character.say(text)


# return character to initial idle animation before dialog
func end() -> void:
	if character == null:
		return
		
	character.set_animation_prefix(inital_animation_prefix)
	character._play_idle()
