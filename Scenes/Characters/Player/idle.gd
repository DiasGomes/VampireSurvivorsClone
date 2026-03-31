extends NodeState

@export var player: Player

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	player.move_input()
	player.mouse_input()


func _on_next_transitions() -> void:
	if player.is_moving:
		transition.emit("Run")


func _on_enter() -> void:
	player.my_sprites.play("idle")


func _on_exit() -> void:
	pass
