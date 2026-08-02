class_name Player
extends CharacterBody2D

@export var sprite: CharacterSprite
@export var speed: float = 150.0

## BL: this fires 60 times per second where just _process is tied to frame rate
func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	move_and_slide()

#region class api

func display(character: Character) -> void:
	sprite.display(character)

#endregion
