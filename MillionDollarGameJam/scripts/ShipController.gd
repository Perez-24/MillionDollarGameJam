extends CharacterBody2D


# WEAPONS
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.18

func shoot() -> void:
	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	# Spawn slightly ahead of the ship.
	bullet.global_position = global_position + Vector2.UP.rotated(rotation) * 30.0
	bullet.set_direction(rotation)

var fire_cooldown: float = 0.0

var speed = 400.0
var angular_speed = PI

var acceleration = 200.0
var friction = 100.0

#CONTROL ENGINE FLICKER ANIMATION
@onready var animationplayer: AnimationPlayer = $Jets/AnimationPlayer
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
		var movement = Vector2.UP.rotated(rotation) * speed
		velocity = velocity.move_toward(movement, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	$Jets.visible = Input.is_action_pressed("ui_up")

	move_and_slide()
	
	fire_cooldown = maxf(fire_cooldown - delta, 0.0)

	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		shoot()
		fire_cooldown = fire_rate
	
