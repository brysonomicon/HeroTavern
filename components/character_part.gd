extends Resource
class_name CharacterPart

@export var slot:Character.Slot
@export var displayName:String
@export var texture:Texture2D
@export var defaultColor:Color
static var default_palette: CompressedTexture2D = preload("res://assets/palettes/palette_character.png")

# Static generator method
# CB: you can't have multiple constructors, so this is my way to work around
# that fact.
static func factory(
	slotType: Character.Slot,
	name: String,
	texture2d: Texture2D, 
	color:Color = Color.TRANSPARENT
) -> CharacterPart:
	# If the texture is null, we don't care about the color
	if texture2d == null:
		color = Color.TRANSPARENT
	# If the texture isn't null, but the color is set to be transparent,
	elif color.a == Color.TRANSPARENT.a:
		color = get_default_slot_color(slotType)
	#var newColor: Color = color if (
			#texture2d != null and color.a == 0
		#) else get_default_slot_color(slotType)
	var newPart: CharacterPart = CharacterPart.new()
	newPart.slot = slotType
	newPart.displayName = name
	newPart.texture = texture2d
	newPart.defaultColor = color
	
	return newPart
	
static func get_default_slot_color(slotType: Character.Slot) -> Color:
	var index: int = int(slotType) + 2 # 0th slot is transparent. 1st slot is outline. 
	var color = default_palette.get_pixel(index, 0)
	return color
