class_name Orbe
extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_shape.disabled = true
		body.add_score()
		queue_free()
