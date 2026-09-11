extends Node

var dog_petted = false

func click_anim(prop: PopochiuProp) -> void:
	var anim_player = prop.find_child("AnimationPlayer") as AnimationPlayer
	
	if anim_player == null:
		return
	
	if !(anim_player.has_animation("default") and anim_player.has_animation("click")):
		return
	
	prop.play_animation("click")
	await anim_player.animation_finished
	prop.play_animation("default")
