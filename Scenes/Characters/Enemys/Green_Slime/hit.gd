extends NodeState

@export var slime: Enemy
@onready var hit_timer: Timer = $HitTimer

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if slime.hit == false:
		transition.emit("Idle")
	if slime.life <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	slime.my_sprites.play("hit")
	hit_timer.timeout.connect(_on_hit_timer_timeout)
	hit_timer.wait_time = slime.hit_timer_wait_time
	hit_timer.start()


func _on_exit() -> void:
	hit_timer.stop()


func _on_hit_timer_timeout() -> void:
	slime.hit = false
