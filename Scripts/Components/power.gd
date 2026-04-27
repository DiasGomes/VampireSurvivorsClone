class_name Power
extends Node

@export var player: Player
@export var power:PowerDefinition

var camera:Camera2D
var cameraShakeNoise:FastNoiseLite


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
