extends RigidBody2D

var speed = 20
var player_pos
var target_pos
@onready var player = get_parent().get_node("Ship_PLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	
	if position.distance_to(player_pos) > 3:
		position += 2* target_pos * speed * delta
		
		
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
