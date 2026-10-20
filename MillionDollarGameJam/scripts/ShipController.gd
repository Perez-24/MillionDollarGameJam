extends CharacterBody2D

@onready var explosion = $Explosion
@onready var health_bar = $"../HealthBar/TextureRect"
@onready var loot_counter = $"../Counter/Counter"
@export var health_textures: Array[Texture2D] = []
@export var max_health: int = 8
@onready var explosion_sfx: AudioStreamPlayer = $AudioStreamBlowUpShip
@onready var takeDamage_sfx: AudioStreamPlayer = $AudioStreamTakeDamage
@onready var playerText = $PlayerText

var health: int = 8
var damage_cooldown: float = 1.0
var damage_timer: float = 0.0
var is_destroyed: bool = false


signal health_changed(current_health: int)
signal ship_destroyed

func update_health_bar() -> void:
	if health_bar == null or health_textures.is_empty():
		return

	var index = max_health - health

	index = clampi(index, 0, health_textures.size() - 1)
	health_bar.texture = health_textures[index]
	
func play_explosion() -> void:
	is_destroyed = true
	velocity = Vector2.ZERO
	$Jets.hide()
	explosion.show()
	explosion.play("default")
	explosion_sfx.play()


func takeDamage(amount: int = 1) -> void:
	if health <= 0 or damage_timer > 0.0:
		return

	health = max(health - amount, 0)
	health_bar.update_health_bar(health, max_health)
	damage_timer = damage_cooldown
	takeDamage_sfx.play()

	health_changed.emit(health)
	print("Ship health: ", health, "/", max_health)

	if health <= 0:
		ship_destroyed.emit()
		play_explosion()
		print("You are dead! Game Over")
		print("Conglaturation!")
		playerText.text = "You and your friends are dead"
		playerText.show()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://MillionDollarGameJam/scenes/title.tscn")

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

var speed = 200.0
var angular_speed = PI

var acceleration = 100.0
var friction = 100.0

#LOOT LOGIC
var loot_count: int = 0

func collect_loot() -> void:
	loot_count += 1
	print("Loot collected: ", loot_count, "/4")
	loot_counter.update_loot(loot_count)
	if loot_count == 4:
		print("Conglaturation!")
		playerText.show()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://MillionDollarGameJam/scenes/credits.tscn")

#CONTROL ENGINE FLICKER ANIMATION
@onready var animationplayer: AnimationPlayer = $Jets/AnimationPlayer
func _ready() -> void:
		health = max_health
		animationplayer.play("Jet Combustion")
		health_bar.update_health_bar(health, max_health)
		loot_counter.update_loot(loot_count)

#TANK CONTROLS
func _physics_process(delta):
	#If ship is destroyed, disable controls
	if is_destroyed:
		return
	var direction = 0.0
	damage_timer -= delta

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
	
	if damage_timer > 0.0:
		damage_timer -= delta

	for i in get_slide_collision_count():
		takeDamage()
	
	fire_cooldown = maxf(fire_cooldown - delta, 0.0)
	if Input.is_action_pressed("ui_select") and fire_cooldown <= 0.0:
		#print("shoot!")
		shoot()
		fire_cooldown = fire_rate
	
