extends HBoxContainer

signal ON_SELECTED_CHANGED(category:String, item:CharacterPart)

@export_dir var directory:String

# Name of the body part to change
# TODO: Find a way to use export to hook directly into the component rather than using a string ref.
@export var category:String

@export var leftButton: Button
@export var rightButton: Button

@export var label: Label

var items: Array[CharacterPart] = []
var index:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var dir: DirAccess = DirAccess.open(directory)
	
	# If we get an invalid folder; return.
	# TODO: Throw an exception.
	if !dir:
		return
	
	dir.list_dir_begin()
	var file: String = dir.get_next()
	# Empty string is invalid input
	while file != "":
		# Don't append subdirectories
		if !dir.current_is_dir():
			items.append(load("%s/%s" % [directory, file]) as CharacterPart)
		
		file = dir.get_next()
	
	# After we populate the array, set the label using the display name
	label.text = items[index].displayName


func next_item():
	index += 1
	
	if(index == items.size()):
		index = 0

	change_selection()
	
func prev_item():
	index -= 1
	
	if(index < 0):
		index = items.size() - 1
		
	change_selection()

func change_selection():
	label.text = items[index].displayName
	ON_SELECTED_CHANGED.emit(category, items[index])
