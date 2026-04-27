class_name PowersManager
extends Node2D

@export var player: Player
@onready var fire_ball: Power = $FireBall


func _ready() -> void:
	fire_ball.player = player
	fire_ball.set_camera()
