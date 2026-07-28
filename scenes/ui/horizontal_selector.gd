class_name HorizontalSelector
extends HBoxContainer

signal part_selected(item:CharacterPart)

@export_dir var directory:String

@export var slot: Character.Slot
@export var slotLabel: Label
@export var leftButton: Button
@export var rightButton: Button

@export var label: Label

var items: Array[CharacterPart] = []
var index:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slotText: String = Character.Slot.keys()[slot]
	slotLabel.text = slotText.to_snake_case().capitalize()
	var dir: DirAccess = DirAccess.open(directory)
	
	assert(dir != null)
	
	dir.list_dir_begin()
	var file: String = dir.get_next()
	# Empty string is invalid input
	while file != "":
		# Don't append subdirectories
		if !dir.current_is_dir():
			items.append(load(directory.path_join(file)) as CharacterPart)
		
		file = dir.get_next()
	
	# Throw is items is empty
	assert(items.is_empty() == false)
	
	# After we populate the array, set the label using the display name
	_apply()

func current() -> CharacterPart:
	return items[index]

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
	label.text = items[index].displayName.capitalize()
	part_selected.emit(items[index])
