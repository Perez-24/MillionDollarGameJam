extends CharacterBody2D

var speed = 400.0
var angular_speed = PI

var acceleration = 200.0
var friction = 100.0

#CONTROL ENGINE FLICKER ANIMATION
@onready var animationplayer: AnimationPlayer = $Jets/AnimationPlayer
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
func _ready() -> void:
		animationplayer.play("Jet Combustion")

#TANK CONTROLS
func _physics_process(delta):
	var direction = 0.0

	if Input.is_action_pressed("ui_left"):
		direction = -1.0
	if Input.is_action_pressed("ui_right"):
		direction = 1.0

	rotation += angular_speed * direction * delta

	if Input.is_action_pressed("ui_up"):
		sound.play()
		var movement = Vector2.UP.rotated(rotation) * speed
		velocity = velocity.move_toward(movement, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	$Jets.visible = Input.is_action_pressed("ui_up")

	move_and_slide()
	
