class_name StatRow
extends HBoxContainer

signal increment_stat(stat_key: String)
signal decrement_stat(stat_key: String)

@export var stat_key: String
@export var display_name: String

@export var name_label: Label 
@export var value_label: Label 
@export var minus_button: Button 
@export var plus_button: Button  

func _ready() -> void:
	name_label.text = display_name
	plus_button.pressed.connect(_on_plus)
	minus_button.pressed.connect(_on_minus)
	
## signal handlers

func _on_plus() -> void:
	increment_stat.emit(stat_key)
	
func _on_minus() -> void:
	decrement_stat.emit(stat_key)

## class api

func set_value(value: int) -> void:
	value_label.text = str(value)
	
func toggle_increment(status: bool) -> void:
	plus_button.disabled = not status
	
func toggle_decrement(status: bool) -> void:
	minus_button.disabled = not status
