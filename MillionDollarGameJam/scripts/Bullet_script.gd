
extends Area2D

@export var speed: float = 250.0
@export var lifetime: float = 1.5

var direction: Vector2 = Vector2.UP

func _ready() -> void:
	# Bullet hits wall
	body_entered.connect(_on_body_entered)

	# Despawn bullet after long enough time
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func set_direction(ship_rotation: float) -> void:
	direction = Vector2.UP.rotated(ship_rotation)
	global_rotation = ship_rotation

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit()
	queue_free()
