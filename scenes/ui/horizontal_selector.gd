class_name HorizontalSelector
extends HBoxContainer

signal part_selected(item:CharacterPart)

@export_dir var directory:String

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
		
	if items.is_empty():
		return
	
	# After we populate the array, set the label using the display name
	label.text = items[index].displayName

## 
func current() -> CharacterPart:
	return null if items.is_empty() else items[index]

func next_item():
	index += 1
	
	if(index == items.size()):
		index = 0
	_apply()
	
func prev_item():
	index -= 1
	
	if(index < 0):
		index = items.size() - 1	
	_apply()

func _apply() -> void:
	label.text = items[index].displayName
	part_selected.emit(items[index])
