extends Control

signal start_new_game
signal continue_game
signal open_settings

@export var NewGameButton: Button
@export var ContinueButton: Button
@export var SettingsButton: Button
@export var QuitButton: Button

func _ready() -> void:
	NewGameButton.pressed.connect(_on_new_game_pressed)
	ContinueButton.pressed.connect(_on_continue_pressed)
	SettingsButton.pressed.connect(_on_settings_pressed)
	QuitButton.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	print("new game pressed")
	start_new_game.emit()
	
func _on_continue_pressed() -> void:
	print("continue pressed")
	continue_game.emit()
	
func _on_settings_pressed() -> void:
	print("settings pressed")
	open_settings.emit()

func _on_quit_pressed() -> void:
	print("quit pressed")
	get_tree().quit()
