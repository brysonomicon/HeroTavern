extends Control

@export var title: String = "Stat Distribution"

signal complete

const ROLL_MIN: float = 70.0
const ROLL_MAX: float = 99.0
const ROLL_MODE: float = 80.0

@export var rows: Array[StatRow]
@export var roll_label: Label
@export var points_left_label: Label
@export var roll_button: Button
@export var store_button: Button
@export var recall_button: Button

var _stats: Dictionary[Character.StatType, int] = {}
var _total: int = 0
var _remaining: int = 0
var _stored: int = -1
var _key_stat: int = -1
var _rng: RandomNumberGenerator

func _ready() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	roll_button.pressed.connect(_on_roll)
	store_button.pressed.connect(_on_store)
	recall_button.pressed.connect(_on_recall)
	for row in rows:
		row.increment_stat.connect(_on_increment)
		row.decrement_stat.connect(_on_decrement)
	_reset()

## signal handlers

func _on_roll() -> void:
	_total = roundi(_sample_triangular(ROLL_MIN, ROLL_MAX, ROLL_MODE))
	_remaining = _total
	_distribute()
	_refresh()

func _on_store() -> void:
	if _total > 0:
		_stored = _total
		_refresh()

func _on_recall() -> void: 
	if _stored < 0:
		return
	_total = _stored
	_remaining = _total
	_distribute()
	_refresh()

func _on_increment(stat_key: Character.StatType) -> void:
	if _remaining > 0 and int(_stats[stat_key]) < Character.STAT_MAX:
		_stats[stat_key] += 1
		_remaining -= 1
		_refresh()

func _on_decrement(stat_key: Character.StatType) -> void:
	var stat_min = Character.KEY_STAT_MIN if stat_key == _key_stat else Character.STAT_MIN
	if int(_stats[stat_key]) > stat_min:
		_stats[stat_key] -= 1
		_remaining += 1
		_refresh()

## class api

func setup(character_class: CharacterClass) -> void:
	if character_class == null:
		return
	_key_stat = character_class.key_stat
	_reset()

func is_complete() -> bool:
	return _total > 0 and _remaining == 0

func assign_property(character: Character) -> void:
	character.stats = _stats.duplicate()

## internals

func _reset() -> void:
	_total = 0
	_remaining = 0
	_stored = -1
	for stat in Character.StatType.values():
		_stats[stat] = Character.KEY_STAT_MIN if stat == _key_stat else Character.STAT_MIN
	_refresh()

func _refresh() -> void:
	var rolled: bool = _total > 0
	roll_label.text = "%d" % _total if rolled else "-"
	points_left_label.text = "%d" % _remaining if rolled else "-"
	for row in rows:
		var stat_min = Character.KEY_STAT_MIN if row.stat_key == _key_stat else Character.STAT_MIN
		var value: int = int(_stats.get(row.stat_key, stat_min))
		row.set_value(value)
		row.toggle_increment(rolled and value < Character.STAT_MAX and _remaining > 0)
		row.toggle_decrement(rolled and value > stat_min)
	store_button.disabled = not rolled
	recall_button.disabled = _stored < 0
	complete.emit()

func _sample_triangular(roll_min: float, roll_max: float, mode: float) -> float:
	## get a sample between 0 - 1.0
	var sample: float = randf()
	## express the position of the peak as a value between 0 - 1.0
	var peak = (mode - roll_min) / (roll_max - roll_min)

	if sample < peak:
		## sample the rising side
		return roll_min + sqrt(sample * (roll_max - roll_min) * (mode - roll_min))
	else:
		## sample the falling side
		return roll_max - sqrt((1.0 - sample) * (roll_max - roll_min) * (roll_max - mode))

func _distribute() -> void:
	for stat in Character.StatType.values():
		_stats[stat] = Character.KEY_STAT_MIN if stat == _key_stat else Character.STAT_MIN
		_remaining = (
			(_remaining - Character.KEY_STAT_MIN)
			if stat == _key_stat
			else (_remaining - Character.STAT_MIN)
		)
	while _remaining > 0:
		var candidates: Array = []
		for stat in Character.StatType.values():
			if int(_stats[stat]) < Character.STAT_MAX:
				candidates.append(stat)
		var pick: Character.StatType = candidates[_rng.randi_range(0, candidates.size() - 1)]
		_stats[pick] += 1
		_remaining -= 1
