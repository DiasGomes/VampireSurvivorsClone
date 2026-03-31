class_name Slime
extends Entity

@warning_ignore("unused_signal")
signal died
var target_position:Vector2
@onready var slime_particles: GPUParticles2D = $SlimeParticles
var particle_material:ParticleProcessMaterial

func start_slime(player_position:Vector2) -> void:
	target_position = player_position
	position = Vector2.ZERO
	particle_material = slime_particles.process_material
	start(80)
	
func emit_particle(_direction:Vector2) -> void:
	particle_material.direction = Vector3(_direction.x, _direction.y, 0)
	slime_particles.restart()
	slime_particles.emitting = true
