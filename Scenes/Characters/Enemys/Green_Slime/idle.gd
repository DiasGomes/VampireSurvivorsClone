extends NodeState

@export var slime: Enemy

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	slime.my_sprites.flip_h = slime.velocity.x < 0
	slime.my_direction = slime.target_position - slime.position
	slime.velocity = slime.my_direction.normalized() * slime.my_speed
	slime.move_and_slide()


func _on_next_transitions() -> void:
	if slime.my_hit:
		transition.emit("Hit")
	if slime.my_health <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	slime.my_sprites.play("idle")


func _on_exit() -> void:
	pass
