extends NodeState

@export var player: Player

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	player.move_input()
	player.velocity = player.my_direction.normalized() * player.my_speed
	player.move_and_slide()


func _on_next_transitions() -> void:
	if player.my_is_moving == false:
		transition.emit("Idle")


func _on_enter() -> void:
	player.my_sprites.play("run")


func _on_exit() -> void:
	pass
