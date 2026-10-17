extends RigidBody2D

@export var min_speed: float = 40.0
@export var max_speed: float = 120.0

@export var min_spin: float = 0.3
@export var max_spin: float = 1.5

func _ready() -> void:
	gravity_scale = 0.0

	# Give the asteroid a random starting velocity
	var direction = Vector2.RIGHT.rotated(
		randf_range(0.0, TAU)
	)

	linear_velocity = direction * randf_range(
		min_speed, max_speed
	)

	# Random rotation speed and direction
	angular_velocity = randf_range(
		min_spin, max_spin
	) * [-1.0, 1.0].pick_random()
