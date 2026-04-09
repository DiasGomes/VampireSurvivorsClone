extends NodeState

@export var inimigo: Inimigo

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	inimigo.my_sprites.flip_h = inimigo.velocity.x < 0
	inimigo.direction = inimigo.target_position - inimigo.position
	inimigo.velocity = inimigo.direction.normalized() * inimigo.speed
	inimigo.move_and_slide()


func _on_next_transitions() -> void:
	if inimigo.hit:
		transition.emit("Hit")
	if inimigo.life <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	inimigo.my_sprites.play("idle")


func _on_exit() -> void:
	pass
