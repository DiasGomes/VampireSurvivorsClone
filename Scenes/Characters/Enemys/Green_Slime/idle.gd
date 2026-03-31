extends NodeState

@export var slime: Slime

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	slime.my_sprites.flip_h = slime.velocity.x < 0
	slime.direction = slime.target_position - slime.position
	slime.velocity = slime.direction.normalized() * slime.speed
	slime.move_and_slide()


func _on_next_transitions() -> void:
	if slime.hit:
		transition.emit("Hit")
	if slime.life <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	slime.my_sprites.play("idle")


func _on_exit() -> void:
	pass
