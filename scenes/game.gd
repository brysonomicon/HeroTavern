extends Node

@export var screen_manager: Node

const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")
const SETTINGS: PackedScene = preload("res://scenes/settings.tscn")
const CHAR_CREATOR: PackedScene = preload("res://scenes/character_creator/creator_main.tscn")

var _current_screen: Node = null

## just temporary place to store created characters until they have a permanent
## home
var	hero_roster: Array = []

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	var menu: Node = goto(MAIN_MENU)
	menu.start_new_game.connect(_on_start_new_game)
	menu.continue_game.connect(_on_continue_game)
	menu.open_settings.connect(_on_open_settings)

func goto(scene: PackedScene) -> Node:
	var screen: Node = scene.instantiate()
	_set_screen(screen)
	return screen
	
func _set_screen(screen: Node) -> void:
	if _current_screen:
		_current_screen.queue_free()
	_current_screen = screen
	screen_manager.add_child(screen)
	
## opens the character creator for now, later will open the game world
func _on_start_new_game() -> void:
	var char_creator: Node = CHAR_CREATOR.instantiate()
	char_creator.character_created.connect(_on_char_created)
	_set_screen(char_creator)

func _on_char_created(data) -> void:
	hero_roster.append(data)
	_show_main_menu()
	
func _on_continue_game() -> void:
	pass
	
func _on_open_settings() -> void:
	var settings: Node = goto(SETTINGS)
	settings.closed.connect(_show_main_menu)
