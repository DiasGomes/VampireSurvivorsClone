extends Power

@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Sprite2D/Area2D
@onready var collision_shape_2d: CollisionShape2D = $Sprite2D/Area2D/CollisionShape2D

func _ready() -> void:
	timer.wait_time = power.cooldown
	timer.start()
	sprite.scale = Vector2(power.size,power.size)
	
func _physics_process(delta: float) -> void:
	sprite.rotate(deg_to_rad(180) * delta)
	
func power_active() -> void:
	for enemy_inside in lst_enemys_detected:
		var damage:float = power.damage
		var critical: bool = false
		var direction:Vector2 = (enemy_inside.position - player.position).normalized()
		if randf() < power.critical:
			damage = damage * 2
			critical = true
		enemy_inside.apply_damage(damage)
		enemy_inside.show_damage(damage, critical)
		enemy_inside.emit_particle(direction)


func _on_area_2d_body_entered(body: Node2D) -> void:
	lst_enemys_detected.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	lst_enemys_detected.erase(body)

func _on_timer_timeout() -> void:
	if power.active:
		power_active()
