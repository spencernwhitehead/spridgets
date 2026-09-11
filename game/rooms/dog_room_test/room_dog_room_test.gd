# @popochiu-docs-ignore-class
@tool
extends PopochiuRoom

const Data := preload('room_dog_room_test_state.gd')

var state: Data = load("res://game/rooms/dog_room_test/room_dog_room_test.tres")

@onready var progress_bar: ProgressBar = $ProgressBar


#region Virtual ####################################################################################
# Called when Popochiu loads the room. At this point the room is in the scene tree but not yet
# visible.
# Add any code you want to setup the stage before the room is shown to the player (e.g. setting
# character position and facing direction, active walkable area, props visibility, etc.).
func _on_room_entered() -> void:
	#Cursor.show_cursor("pet_idle", true)
	get_prop("Back").visible = false
	C.DogTest.drag_amount_updated.connect(progress_bar.update_progress.bind())
	progress_bar.completed.connect(_on_complete.bind())


func _on_complete() -> void:
	Globals.dog_petted = true
	get_prop("Back").visible = true


# Called after the room transition completes; the room is now visible.
# Implement this to start cutscenes, play sounds, etc.
# NOTE: this is NOT called when loading a saved game. Use [_on_restore_from_savegame] for that.
func _on_room_transition_finished() -> void:
	# You can use await E.queue([]) to run a sequence of actions here.
	pass


# Called before Popochiu unloads the room.
# At this point the screen is black, processing is disabled, and characters
# have been removed from the $Characters node.
# Implement cleanup code, handle custom data or states before leaving the room, etc. if needed.
func _on_room_exited() -> void:
	pass


# Called after loading a saved game. The state of the room and all its objects is
# completely restored at this point. Use this to resume ongoing events,
# re-establish connections, or restart ambient audio.
# NOTE: `_on_room_transition_finished()` is NOT called when loading a savegame.
# If you need to run its code when loading a savegame, you can call it explicitly from this method.
func _on_restore_from_savegame() -> void:
	pass


#endregion
