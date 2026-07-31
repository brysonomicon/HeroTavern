class_name CharacterSprite
extends Node2D

@export var parts: Dictionary[Character.Slot, Sprite2D]
static var default_palette: Texture2D = load("res://assets/palettes/palette_character.png")
var palette: Texture2D = preload("res://assets/palettes/palette_character.png")
# Cache this, as its expensive to get.
var palette_img: Image

func _ready() -> void:
	var setKeys: Array = parts.keys()
	for required in Character.Slot.values():
		if setKeys.find(required) == -1:
			var keyName:String = Character.Slot.keys()[required]
			var child_node: Node = get_node_or_null(keyName.to_pascal_case())
			assert(child_node != null)
			var spriteNode: Sprite2D = child_node as Sprite2D
			if spriteNode.texture == null:
				spriteNode.texture = Character.default_parts[required].texture
			parts.set(required, spriteNode)
	
	palette_img = default_palette.get_image()
	
	for part in parts:
		var sprite: Sprite2D = parts[part]
		var default_color: Color = palette_img.get_pixel(part + 2, 0)
		sprite.set_instance_shader_parameter("default_color", default_color)
		_update_part_shader(default_color, part)

	
func _update_part_shader(new_color: Color, slot: Character.Slot ) -> void:
	var sprite: Sprite2D = parts[slot]
	sprite.set_instance_shader_parameter("new_color", new_color)
		
func update_shader(new_color: Color, slot: Character.Slot) -> void:
	# +2 because 0th slot is transparency and 1st is outline.
	palette_img.set_pixel(slot + 2, 0, new_color)
	palette = ImageTexture.create_from_image(palette_img)
	_update_part_shader(new_color, slot)

func update_part(new_part: CharacterPart) -> void:
	parts[new_part.slot].texture = new_part.texture
