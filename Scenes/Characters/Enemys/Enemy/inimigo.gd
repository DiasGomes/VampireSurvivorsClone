class_name Inimigo
extends Entity

@export var cena: PackedScene
@export var enemy_status: Status

func _ready() -> void:
	my_sprites = cena.find_child("AnimatedSprite2D")
	my_outline_detection_area = cena.find_child("Area2D")
	set_status(enemy_status)
