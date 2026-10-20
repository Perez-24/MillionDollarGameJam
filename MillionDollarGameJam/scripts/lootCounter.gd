extends TextureRect

# Health states array
@export var loot_textures: Array[Texture2D] = []

func update_loot(lootCount: int) -> void:
	texture = loot_textures[lootCount]
