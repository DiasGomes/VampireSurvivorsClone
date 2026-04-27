extends Power

@onready var area: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var spawner_component: SceneSpawner = $SpawnerComponent

var lst_enemys_detected:Array[Enemy]

func _ready() -> void:
	collision_shape_2d.shape.radius = power.power_range
	timer.wait_time = power.cooldown
	timer.start()

		
func power_active() -> void:
	var closest_enemy:Enemy
	var min_enemy_dist:float
	for enemy in lst_enemys_detected:
		var enemy_dist:float = player.position.distance_to(enemy.position)
		if min_enemy_dist:
			if enemy_dist < min_enemy_dist:
				min_enemy_dist = enemy_dist
				closest_enemy = enemy
		else:
			min_enemy_dist = enemy_dist
			closest_enemy = enemy
			
	if closest_enemy:
		create_bullet((closest_enemy.position - player.position).normalized())
		

func create_bullet(_dir:Vector2) -> void:
	print("dist: "+str(_dir))
	var new_bullet:Bullet = spawner_component.spawn(player)
	new_bullet.shake.connect(shake_screen)
	new_bullet.start(_dir, power.damage, power.critical)


func _on_area_2d_body_entered(body: Node2D) -> void:
	lst_enemys_detected.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	lst_enemys_detected.erase(body)


func _on_timer_timeout() -> void:
	if power.active:
		power_active()
		
