extends Node2D

@export var player:Player
@onready var spawner_component:SceneSpawner = $SpawnerComponent

var camera:Camera2D
var cameraShakeNoise:FastNoiseLite

func _ready() -> void:
	camera = player.find_child("Camera2D")
	cameraShakeNoise = FastNoiseLite.new()
	player.shoot.connect(create_bullet)

func create_bullet(_dir:Vector2, _damage:int, _critical:float) -> void:
	var new_bullet:Bullet = spawner_component.spawn(player)
	new_bullet.shake.connect(shake_screen)
	new_bullet.start(_dir, _damage, _critical)
	
func startCameraShake(intensity:float=0.5) -> void:
	var cameraOffset:float = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera.offset.x = cameraOffset
	camera.offset.y = cameraOffset
	
func shake_screen(_duration:float = 0.5) -> void:
	var tween:Tween = get_tree().create_tween()
	# start_vaue, ende_value, duracao
	tween.tween_method(startCameraShake, 5.0, 1.0, _duration) 
