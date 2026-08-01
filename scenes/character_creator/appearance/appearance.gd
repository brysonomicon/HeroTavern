extends Control

@export var title: String = "Appearance"
@export var preview: CharacterSprite
@export var skin_color_button: ColorPickerButton
@export var eye_color_button: ColorPickerButton
@export var selectors: Array[HorizontalSelector]
	
func assign_property(hero: Character) -> void:
	for selector in selectors:
		var part: CharacterPart = selector.current()
		if part:
			hero.parts[part.slot] = part
		hero.part_colors[selector.slot] = selector.colorPicker.color
