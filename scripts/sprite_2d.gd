extends CharacterBody2D

var speed = 400.0
var angular_speed = PI

func _physics_process(delta):
	var direction = 0.0

	if Input.is_action_pressed("ui_left"):
		direction = -1.0
	if Input.is_action_pressed("ui_right"):
		direction = 1.0

	rotation += angular_speed * direction * delta

	var movement = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		movement = Vector2.UP.rotated(rotation) * speed

	velocity = movement
	move_and_slide()
