extends RigidBody2D

var speed = 2

var player_pos
var target_pos

@onready var player = get_parent().get_node("Player")

@onready var sound : AudioStreamPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#func _physics_process(delta: float) -> void:
	#player_pos = player.position
	#target_pos = (player_pos - position).normalized()
	#
	#if position.distance_to(player_pos) > 1:
		#position += target_pos * speed * delta
		#
