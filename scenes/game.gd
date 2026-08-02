extends Node

@export var screen_host: Node

const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")
const SETTINGS: PackedScene = preload("res://scenes/settings.tscn")
const CHAR_CREATOR: PackedScene = preload("res://scenes/character_creator/creator_main.tscn")
const WORLD: PackedScene = preload("res://scenes/world/world.tscn")
const TAVERN_MANAGER_CREATOR: PackedScene = preload("res://scenes/character_creator/tavern_manager_creator/manager_creator.tscn")

const SAVE_PATH: String = "user://save.tres"
const SAVE_TMP_PATH: String = "user://save.tmp.tres"

var _current_screen: Node = null
var state: GameState

func _ready() -> void:
	_load_state()
	_show_main_menu()

#region signal handlers
func _on_start_new_game() -> void:
	state = GameState.new()
	var creator: Node = goto(TAVERN_MANAGER_CREATOR)
	creator.character_created.connect(_on_manager_created)

func _on_manager_created(manager: Character) -> void:
	state.tavern_manager = manager
	_save_state()
	_enter_world()

#func _on_char_created(data) -> void:
	#hero_roster.heroes.append(data)
	#_save_roster()
	#_show_main_menu()
	
func _on_continue_game() -> void:
	if state.tavern_manager == null:
		print("No tavern manager - imagine this is greyed out")
		return
	_enter_world()

func _on_open_settings() -> void:
	var settings: Node = goto(SETTINGS)
	settings.closed.connect(_show_main_menu)
#endregion

#region internals

func _enter_world() -> void:
	var world: Node = goto(WORLD)
	world.setup(state)

func _load_state() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		state = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as GameState
	if state == null:
		state = GameState.new()

func _save_state() -> void:
	var error: Error = ResourceSaver.save(state, SAVE_TMP_PATH)
	if error != OK:
		push_error("Error saving: %s" % error_string(error))
		return
	DirAccess.rename_absolute(SAVE_TMP_PATH, SAVE_PATH)

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
