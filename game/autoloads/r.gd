@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PRTestRoom2 := preload("res://game/rooms/test_room_2/room_test_room_2.gd")
const PRBlueRoom := preload("res://game/rooms/blue_room/room_blue_room.gd")
const PRDogRoomTest := preload("res://game/rooms/dog_room_test/room_dog_room_test.gd")
# ---- classes

# nodes ----
var TestRoom2: PRTestRoom2 : get = get_TestRoom2
var BlueRoom: PRBlueRoom : get = get_BlueRoom
var DogRoomTest: PRDogRoomTest : get = get_DogRoomTest
# ---- nodes

# functions ----
func get_TestRoom2() -> PRTestRoom2: return get_runtime_room("TestRoom2")
func get_BlueRoom() -> PRBlueRoom: return get_runtime_room("BlueRoom")
func get_DogRoomTest() -> PRDogRoomTest: return get_runtime_room("DogRoomTest")
# ---- functions

