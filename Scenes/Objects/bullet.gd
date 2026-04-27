class_name Bullet
extends CharacterBody2D

var direction:Vector2
var speed:float = 200.0
var damage:float
var critical_per:float
@onready var sprite: Sprite2D = $Sprite2D
signal shake

func start(_dir:Vector2, _damage:float, _critical_per:float) -> void:
	direction = _dir
	damage = _damage
	critical_per = _critical_per
	velocity = direction * speed
	scale = Vector2(0.5, 0.5)
	var new_angle:float = atan2(direction.y, direction.x)
	sprite.rotation = new_angle
	

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var critical: bool = false
		if randf() < critical_per:
			damage = damage * 2
			critical = true
		body.apply_damage(damage)
		body.show_damage(damage, critical)
		body.emit_particle(direction)
		shake.emit()
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
