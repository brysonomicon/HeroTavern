extends Control

@export var title: String = "Appearance"
@export var preview: CharacterTextureBox
@export var skin_color_button: ColorPickerButton
@export var eye_color_button: ColorPickerButton
@export var selectors: Array[HorizontalSelector]
	
func assign_property(hero: Character) -> void:
	hero.skin_color = skin_color_button.color
	hero.eye_color = eye_color_button.color
	for selector in selectors:
		var part: CharacterPart = selector.current()
		if part:
			hero.parts[part.slot] = part
