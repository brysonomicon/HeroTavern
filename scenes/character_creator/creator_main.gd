extends Control

signal character_created(data)

@export var steps: Array[Control]
@export var back_button: Button
@export var next_button: Button
@export var title_label: Label

var _current: int = 0

func _ready() -> void:
	back_button.pressed.connect(_on_back)
	next_button.pressed.connect(_on_next)
	_show_step(0)
	
func _show_step(index: int) -> void:
	for i in steps.size():
		steps[i].visible = (i == index)
	_current = index
	back_button.disabled = (index == 0)
	title_label.text = steps[index].get("title")
	if _current == (steps.size() - 1):
		next_button.text = "Complete"
	else:
		next_button.text = "Next"
	
	
func _on_next() -> void:
	if _current < steps.size() - 1:
		_show_step(_current + 1)
	else:
		_finish()

# ong bak tony jaa 
func _on_back() -> void:
	if _current > 0:
		_show_step(_current - 1)
		
# gather data from fields and export to object
func _finish() -> void:
	character_created.emit(_build_character())
	
# this will return a Character object or whatever when it exists
func _build_character():
	## capture all the character details here
	return null
