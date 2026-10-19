extends TextureRect

# Health states array
@export var health_textures: Array[Texture2D] = []

func update_health_bar(health: int, max_health: int) -> void:
	var index = clampi(max_health - health, 0, health_textures.size() - 1)
	texture = health_textures[index]
