extends NodeState

@export var slime: Slime
@export var timer: Timer
@export var collision_shape: CollisionShape2D

func _on_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	slime.my_sprites.play("died")
	collision_shape.disabled = true
	timer.start()


func _on_exit() -> void:
	pass


func _on_dead_timer_timeout() -> void:
	slime.died.emit(slime)
	slime.queue_free()
