extends Node

@export var screen_host: Node

const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")
const SETTINGS: PackedScene = preload("res://scenes/settings.tscn")
const CHAR_CREATOR: PackedScene = preload("res://scenes/character_creator/creator_main.tscn")

var _current_screen: Node = null

const ROSTER_PATH: String = "user://roster.tres"
const ROSTER_TMP_PATH: String = "user://roster.tmp.tres"

var	hero_roster: HeroRoster

func _ready() -> void:
	_show_main_menu()
	_load_roster()

#region signal handlers
func _on_start_new_game() -> void:
	var char_creator: Node = CHAR_CREATOR.instantiate()
	char_creator.character_created.connect(_on_char_created)
	_set_screen(char_creator)

func _on_char_created(data) -> void:
	hero_roster.heroes.append(data)
	_save_roster()
	_show_main_menu()
	
func _on_continue_game() -> void:
	if hero_roster.heroes.is_empty():
		print("Hero roster is empty")
	else:
		print("=== Hero Roster: [%d] ===" %hero_roster.heroes.size())
		for hero in hero_roster.heroes:
			print(hero)

func _on_open_settings() -> void:
	var settings: Node = goto(SETTINGS)
	settings.closed.connect(_show_main_menu)
#endregion

#region internals
func _load_roster() -> void:
	if ResourceLoader.exists(ROSTER_PATH):
		hero_roster = ResourceLoader.load(ROSTER_PATH) as HeroRoster
	if hero_roster == null:
		hero_roster = HeroRoster.new()

func _save_roster() -> void:
	var error: Error = ResourceSaver.save(hero_roster, ROSTER_TMP_PATH)
	
	if error != OK:
		push_error("Error saving roster: %s" % error_string(error))
		return
	DirAccess.rename_absolute(ROSTER_TMP_PATH, ROSTER_PATH)

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
	screen_host.add_child(screen)
#endregion
