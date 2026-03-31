class_name Entity
extends CharacterBody2D

@export var my_sprites:AnimatedSprite2D
@export var outline_detection_area:Area2D

var direction:Vector2
var hit:bool
var is_moving:bool
var speed:int
var life:int
@export var max_life:int = 10

# Variaveis para spring effect
var spring_rigidness:float = 0.1
var spring_damping:float = 0.2
var spring_velocity:float = 0.0
var squish_target:float = 1.0

func start(_speed_value:int) -> void:
	direction = Vector2.ZERO
	hit = false
	is_moving = false
	speed = _speed_value
	life = max_life
	if outline_detection_area:
		outline_detection_area.mouse_entered.connect(_on_outline_area_mouse_entered)
		outline_detection_area.mouse_exited.connect(_on_outline_area_mouse_exited)

func apply_damage(_value:int, _blink_value:float=0.5) -> void:
	hit = true
	life -= _value
	blink(_blink_value)
	
	
# FUNCOES QUE FAZEM O PERSONAGEM LAMPEJAR
# ATENCAO: usar em conjunto com um Material com "entity_geral_shader" ou "blink.gdshader"
func blink(_duration:float = 0.5) -> void:
	var tween:Tween = get_tree().create_tween()
	# start_vaue, ende_value, duracao
	tween.tween_method(setShader_BlinkIntensity, 1.0, 0.0, _duration) 
	
func setShader_BlinkIntensity(_value:float) -> void:
	my_sprites.material.set_shader_parameter("blink_intesity", _value)
	
# FUNCAO QUE ATIVA E DESATIVA O OUTLINE
# ATENCAO: usar em conjunto com um Material com "entity_geral_shader" ou "outline.gdshader"
func outline(_value:bool) -> void:
	my_sprites.material.set_shader_parameter("active_outline", _value)
	
func _on_outline_area_mouse_entered() -> void:
	outline(true)

func _on_outline_area_mouse_exited() -> void:
	outline(false)

# FUNCAO QUE CONTRAI O SPRITE
func spring() -> void:
	var distance_to_destination:float = my_sprites.scale.x  - squish_target
	var loss:float = spring_damping * spring_velocity
	# Hooke's law
	var force:float = -spring_rigidness * distance_to_destination - loss
	spring_velocity += force
	my_sprites.scale.x  += spring_velocity	
	my_sprites.scale.y = 2.0 - my_sprites.scale.x 
	
