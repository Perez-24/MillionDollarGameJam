extends TextureRect

# Health states array
@export var loot_textures: Array[Texture2D] = []

func update_loot(lootCount: int) -> void:
	texture = loot_textures[lootCount]
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MillionDollarGameJam/scenes/Title.tscn")
