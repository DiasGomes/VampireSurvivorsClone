class_name Entity
extends CharacterBody2D

@export var my_sprites:AnimatedSprite2D
@export var outline_detection_area:Area2D
@export var label_settings: LabelSettings
@export var critical_hit_color: Color = Color.RED

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
	
# mostra dano sofrido
func show_damage(number: float, critical_hit: bool = false) -> void:
	# cria um label com o numero do dano
	var new_label: Label = Label.new()
	new_label.text = str(number if step_decimals(number) != 0 else number as int)
	new_label.label_settings = label_settings.duplicate()
	new_label.z_index = 1000
	new_label.pivot_offset = Vector2(0.5, 1.0)
	# muda a cor se for dano critico
	if critical_hit:
		new_label.label_settings.font_color = critical_hit_color
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
