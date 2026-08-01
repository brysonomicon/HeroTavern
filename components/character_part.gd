extends Resource
class_name CharacterPart

@export var slot:Character.Slot
@export var displayName:String
@export var texture:Texture2D
static var default_palette: Texture2D = preload("res://assets/palettes/palette_character.png")

# Static generator method
# CB: you can't have multiple constructors, so this is my way to work around
# that fact.
static func factory(
	slotType: Character.Slot,
	name: String,
	texture2d: Texture2D,
) -> CharacterPart:
	
	var newPart: CharacterPart = CharacterPart.new()
	newPart.slot = slotType
	newPart.displayName = name
	newPart.texture = texture2d
	
	return newPart
	
static func get_default_color(slotType: Character.Slot) -> Color:
	var palette_img: Image = default_palette.get_image()
	return palette_img.get_pixel(slotType + 2, 0)
	
