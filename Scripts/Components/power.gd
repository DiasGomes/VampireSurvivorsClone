class_name Power
extends Node

@export var player: Player
@export var power:PowerDefinition

var camera:Camera2D
var cameraShakeNoise:FastNoiseLite
var lst_enemys_detected:Array[Enemy]

func set_camera() -> void:
	camera = player.find_child("Camera2D")
	cameraShakeNoise = FastNoiseLite.new()

	
func startCameraShake(intensity:float=0.5) -> void:
	var cameraOffset:float = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = cameraOffset
	camera.offset.y = cameraOffset
	
	
func shake_screen(_duration:float = 0.5) -> void:
	var tween:Tween = get_tree().create_tween()
	# start_vaue, ende_value, duracao
	tween.tween_method(startCameraShake, 5.0, 1.0, _duration)

	
func find_closest_enemy() -> Enemy:
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
	return closest_enemy
