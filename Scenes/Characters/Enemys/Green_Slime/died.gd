extends NodeState

@export var slime: Enemy

func _on_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	slime.died.emit(slime)
	slime.queue_free()


func _on_exit() -> void:
	pass
