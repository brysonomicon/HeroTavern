extends Control

signal character_created(character)

@export var steps: Array[Control]
@export var back_button: Button
@export var next_button: Button
@export var title_label: Label

var _current: int = 0
var _key_stat: String = ""

func _ready() -> void:
	back_button.pressed.connect(_on_back)
	next_button.pressed.connect(_on_next)
	for step in steps:
		if step.has_signal("class_selected"):
			step.class_selected.connect(_on_class_changed)
		if step.has_signal("complete"):
			step.complete.connect(_update_next_enabled)
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
	var step: Control = steps[index]
	if step.has_method("setup"):
		step.setup(_key_stat)
	if step.has_method("review"):
		step.review(Character.new(self))
	_update_next_enabled()

func _on_next() -> void:
	if _current < steps.size() - 1:
		_show_step(_current + 1)
	else:
		_finish()

func _on_class_changed(class_data: Dictionary) -> void:
	_key_stat = class_data.get("key_stat", "")

func _update_next_enabled() -> void:
	var step: Control = steps[_current]
	if step.has_method("is_complete"):
		next_button.disabled = not step.is_complete()
	else:
		next_button.disabled = false

# ong bak tony jaa 
func _on_back() -> void:
	if _current > 0:
		_show_step(_current - 1)

# gather data from fields and export to object
func _finish() -> void:
	character_created.emit(Character.new(self))

func populate(character: Character) -> void:
	for step in steps:
		if step.has_method("assign_property"):
			step.call("assign_property", character)
