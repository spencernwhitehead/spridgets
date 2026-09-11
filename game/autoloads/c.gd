@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCGreenGuy := preload("res://game/characters/green_guy/character_green_guy.gd")
const PCDogTest := preload("res://game/characters/dog_test/character_dog_test.gd")
const PCPlaceholder := preload("res://game/characters/placeholder/character_placeholder.gd")
# ---- classes

# nodes ----
var GreenGuy: PCGreenGuy : get = get_GreenGuy
var DogTest: PCDogTest : get = get_DogTest
var Placeholder: PCPlaceholder : get = get_Placeholder
# ---- nodes

# functions ----
func get_GreenGuy() -> PCGreenGuy: return get_runtime_character("GreenGuy")
func get_DogTest() -> PCDogTest: return get_runtime_character("DogTest")
func get_Placeholder() -> PCPlaceholder: return get_runtime_character("Placeholder")
# ---- functions

