class_name Bullet
extends CharacterBody2D

var direction:Vector2
var speed:float = 2.0
@onready var sprite: Sprite2D = $Sprite2D
signal shake

func start(_dir:Vector2) -> void:
	direction = _dir
	velocity = direction * speed
	scale = Vector2(0.5, 0.5)
	var new_angle:float = atan2(direction.y, direction.x)
	sprite.rotation = new_angle
	

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Slime:
		body.apply_damage(1)
		body.emit_particle(direction)
		shake.emit()
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
