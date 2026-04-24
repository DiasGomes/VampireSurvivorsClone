extends NodeState

@export var enemy: Enemy

func _on_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	enemy.died.emit(enemy)
	enemy.queue_free()


func _on_exit() -> void:
	pass
