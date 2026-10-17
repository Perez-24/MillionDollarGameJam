
extends RigidBody2D

@export var min_speed: float = 40.0
@export var max_speed: float = 120.0

@export var min_spin: float = 0.3
@export var max_spin: float = 1.5

@export var crumble_frame_time: float = 0.15
@export var debris_duration: float = 0.5

@onready var intact_sprite: Sprite2D = $BreakableAstrd0
@onready var broken_sprite: Sprite2D = $BreakableAstrdPhase2
@onready var debris_sprite: Sprite2D = $BreakableAstrdPhase3
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_destroying: bool = false

func _ready() -> void:
	gravity_scale = 0.0

	var direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	linear_velocity = direction * randf_range(min_speed, max_speed)

	angular_velocity = randf_range(min_spin, max_spin) \
		* [-1.0, 1.0].pick_random()

	intact_sprite.visible = true
	broken_sprite.visible = false
	debris_sprite.visible = false

func take_hit() -> void:
	if is_destroying:
		return

	is_destroying = true

	# Disable further collisions and stop movement.
	collision_shape.set_deferred("disabled", true)
	collision_layer = 0
	collision_mask = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	# Crumble animation: intact -> broken -> debris.
	intact_sprite.visible = false
	broken_sprite.visible = true

	await get_tree().create_timer(crumble_frame_time).timeout

	broken_sprite.visible = false
	debris_sprite.visible = true

	# Leave the debris visible briefly, then remove the asteroid.
	await get_tree().create_timer(debris_duration).timeout

	queue_free()
