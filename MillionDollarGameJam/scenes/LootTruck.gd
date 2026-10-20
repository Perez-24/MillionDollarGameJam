extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("Loot truck area ready")
	print("Mask: ", collision_mask, " Monitoring: ", monitoring)
	
func _on_body_entered(body: Node2D) -> void:
	print("Something entered the loot truck: ", body.name)
	if body.name == "Player":
		body.collect_loot()
		queue_free()
