extends Resource
class_name CharacterPart

## lets parts identify what slot they belong to 
enum Slot { SHIRT }

@export var slot: Slot
@export var displayName:String
@export var texture:Texture2D
@export var defaultColor:Color = Color.WHITE
