extends Control
@export var BackButton: Button

func _ready() -> void:
	BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	SceneRouter.back()
