extends NodeState

@export var enemy:Enemy

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	enemy.my_sprites.flip_h = enemy.velocity.x < 0
	enemy.my_direction = enemy.target_position - enemy.position
	enemy.velocity = enemy.my_direction.normalized() * enemy.my_speed
	enemy.move_and_slide()


func _on_next_transitions() -> void:
	if enemy.my_hit:
		transition.emit("Hit")
	if enemy.my_health <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	enemy.my_sprites.play("idle")


func _on_exit() -> void:
	pass
