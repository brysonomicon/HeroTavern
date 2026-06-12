extends Node

# hard coded for "exit to menu" vs "quit game"
const MAIN_MENU: PackedScene = preload("res://scenes/main_menu.tscn")

var _nav_history: Array[String] = []

func goto(scene: PackedScene) -> void:
	var current: String = get_tree().current_scene.scene_file_path
	if current != "":
		_nav_history.append(current)
	
	#if !_nav_history.is_empty():
		#for item in _nav_history:
			#print(item + "\n")
	get_tree().change_scene_to_packed(scene)
	
func back() -> void:
	if _nav_history.is_empty():
		return
	
	#for item in _nav_history:
			#print(item + "\n")
	get_tree().change_scene_to_file(_nav_history.pop_back())
	
