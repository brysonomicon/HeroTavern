extends Control

# register event listeners 
func _ready() -> void:
	$CenterContainer/VBoxContainer/NewGameButton.pressed.connect(_on_new_game_pressed)
	$CenterContainer/VBoxContainer/ContinueButton.pressed.connect(_on_continue_pressed)
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	

func _on_new_game_pressed() -> void:
	print("the gizzy is fresh")
	
func _on_continue_pressed() -> void:
	print("contibule")
	
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
	print("netting")

func _on_quit_pressed() -> void:
	get_tree().quit()
