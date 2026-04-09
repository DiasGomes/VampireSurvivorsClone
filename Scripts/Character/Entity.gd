class_name Entity
extends CharacterBody2D

@export var my_sprites:AnimatedSprite2D
@export var my_outline_detection_area:Area2D
@export var my_label_settings: LabelSettings
@export var my_critical_hit_color: Color = Color.RED
@export var my_status: Status

var my_direction:Vector2
var my_hit:bool
var my_is_moving:bool
var my_speed:float
var my_max_health:float
var my_health:float
var my_damage:float

# Variaveis para spring effect
var my_spring_rigidness:float = 0.1
var my_spring_damping:float = 0.2
var my_spring_velocity:float = 0.0
var my_squish_target:float = 1.0

func start() -> void:
	my_direction = Vector2.ZERO
	my_hit = false
	my_is_moving = false
	set_status()
	if my_outline_detection_area:
		my_outline_detection_area.mouse_entered.connect(_on_outline_area_mouse_entered)
		my_outline_detection_area.mouse_exited.connect(_on_outline_area_mouse_exited)

func apply_damage(_value:int, _blink_value:float=0.5) -> void:
	my_hit = true
	my_health -= _value
	blink(_blink_value)

func set_status(_status: Status = null) -> void:	
	if _status:
		my_status = _status
	# define os valores com base no status
	my_max_health = my_status.max_health
	my_speed = my_status.movement_speed
	my_damage = my_status.damage
	# iguala a vida a vida maxima
	my_health = my_max_health
	
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
	var distance_to_destination:float = my_sprites.scale.x  - my_squish_target
	var loss:float = my_spring_damping * my_spring_velocity
	# Hooke's law
	var force:float = -my_spring_rigidness * distance_to_destination - loss
	my_spring_velocity += force
	my_sprites.scale.x  += my_spring_velocity	
	my_sprites.scale.y = 2.0 - my_sprites.scale.x 
	
# mostra dano sofrido
func show_damage(number: float, critical_hit: bool = false) -> void:
	# cria um label com o numero do dano
	var new_label: Label = Label.new()
	new_label.text = str(number if step_decimals(number) != 0 else number as int)
	new_label.label_settings = my_label_settings.duplicate()
	new_label.z_index = 1000
	new_label.pivot_offset = Vector2(0.5, 1.0)
	# muda a cor se for dano critico
	if critical_hit:
		new_label.label_settings.font_color = my_critical_hit_color
	# ignona iluminacao da cena e dos objetos
	var label_material: CanvasItemMaterial = CanvasItemMaterial.new()
	label_material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	new_label.material = label_material
	# adiciona label na cena
	call_deferred("add_child", new_label)
	await new_label.resized
	new_label.position -= Vector2(new_label.size.x / 2.0, new_label.size.y)
	new_label.position += Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	# animação do label
	var target_rise_pos:Vector2 = new_label.position + Vector2(randf_range(-5.0, 5.0), randf_range(-22.0, -16.0))
	var tween_length:float = 0.92
	var label_tween:Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(new_label, "position", target_rise_pos, tween_length)
	label_tween.parallel().tween_property(new_label, "scale", Vector2.ONE * 1.35, tween_length)
	label_tween.parallel().tween_property(new_label, "modulate:a", 0.0, tween_length).connect("finished", new_label.queue_free)
