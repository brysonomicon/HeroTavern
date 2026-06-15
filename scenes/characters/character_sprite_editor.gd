extends Node

@export var character: TextureRect

func set_sprite_part(category:String, item:CharacterPart):
	var part:TextureRect = character.get_node(category.to_lower()) as TextureRect
	
	if(item.texture == null):
		part.visible = false
	else:
		part.visible = true
		part.texture = item.texture
		part.self_modulate = item.defaultColor

func set_skin_color(color: Color):
	var body: TextureRect = character.get_node("body") as TextureRect
	
	body.self_modulate = color;

func set_eye_color(color: Color):
	var eye: TextureRect = character.get_node("eyes") as TextureRect
	
	eye.self_modulate = color;
