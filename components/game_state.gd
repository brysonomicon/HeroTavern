class_name GameState
extends Resource

@export var tavern_manager: Character
@export var hero_roster: HeroRoster

func _init() -> void:
	if hero_roster == null:
		hero_roster = HeroRoster.new()
