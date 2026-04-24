extends NodeState

@export var enemy: Enemy
@onready var hit_timer: Timer = $HitTimer

func _ready() -> void:
	hit_timer.timeout.connect(_on_hit_timer_timeout)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if enemy.my_hit == false:
		transition.emit("Idle")
	if enemy.my_health <= 0:
		transition.emit("Died")


func _on_enter() -> void:
	enemy.my_sprites.play("hit")
	hit_timer.wait_time = enemy.hit_timer_wait_time
	hit_timer.start()


func _on_exit() -> void:
	hit_timer.stop()


func _on_hit_timer_timeout() -> void:
	enemy.my_hit = false
