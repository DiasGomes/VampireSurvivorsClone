class_name Enemy
extends Entity

@warning_ignore("unused_signal")
signal died

@onready var enemy_particles: GPUParticles2D = $EnemyParticles

@export var hit_timer_wait_time:float = 1.0

var target_position:Vector2
var particle_material:ParticleProcessMaterial

func start_slime(player_position:Vector2) -> void:
	target_position = player_position
	position = Vector2.ZERO
	particle_material = enemy_particles.process_material
	start()
	
	
func emit_particle(_direction:Vector2) -> void:
	particle_material.direction = Vector3(_direction.x, _direction.y, 0)
	enemy_particles.restart()
	enemy_particles.emitting = true
