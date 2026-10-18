extends RigidBody2D


var is_destroying: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

	queue_free()
	
