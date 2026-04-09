extends NodeState

@export var inimigo: Inimigo

func _on_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	inimigo.died.emit(inimigo)
	inimigo.queue_free()


func _on_exit() -> void:
	pass
