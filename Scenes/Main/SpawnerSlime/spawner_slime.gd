class_name SpawnSlime
extends Marker2D

@export var player:Player
@export var game:Game

@onready var spawner_component: SceneSpawner = $SpawnerComponent
@onready var slime_spawn_timer: Timer = $SlimeSpawnTimer
@onready var orbe_spawner_component: SceneSpawner = $OrbeSpawnerComponent

var lst_green_slime:Array[Slime]
var spawn_slime_time:bool
var slime_limit:int = 30
var radius:int = 500
var angle:float = 0


func _ready() -> void:
	spawn_slime_time = true
	player.upgrade.connect(limit_increase)
	print("teste git")
	
func _physics_process(_delta: float) -> void:
	#draw_marker_2d()
	rotated_position_marker(_delta)
	if lst_green_slime.size() < slime_limit:
		if spawn_slime_time:
			spawn_slime()
			
	for slime in lst_green_slime:
		slime.target_position = player.position


func limit_increase(_level:int) -> void:
	slime_limit = 30 + (10 * _level)
	

func rotated_position_marker(_delta: float) -> void: 
	position = player.position + Vector2(radius, 0).rotated(angle)
	angle += 1 * _delta
	if angle >= (2 * PI):
		angle = 0


func spawn_slime() -> void:
	var new_slime:Slime = spawner_component.spawn(game)
	new_slime.start_slime(player.position)
	new_slime.position = position
	new_slime.died.connect(slime_destroy)
	lst_green_slime.append(new_slime)
	spawn_slime_time = false
	slime_spawn_timer.start()
	
	
func spawn_orbe(_position:Vector2) -> void:
	var new_orbe:Orbe = orbe_spawner_component.spawn(game)
	new_orbe.position = _position
	

func slime_destroy(_body:Slime) -> void:
	spawn_orbe(_body.position)
	lst_green_slime.erase(_body)


func _on_slime_spawn_timer_timeout() -> void:
	spawn_slime_time = true

# funcoes de debug
func _draw() -> void:
	if Engine.is_editor_hint() or OS.is_debug_build():
		draw_line(Vector2(-10, 0), Vector2(10, 0), Color(1, 0, 0), 2)
		draw_line(Vector2(0, -10), Vector2(0, 10), Color(1, 0, 0), 2)
		draw_circle(Vector2.ZERO, 3, Color(0, 0, 1))

func draw_marker_2d() -> void:
	if Engine.is_editor_hint() or OS.is_debug_build():
		queue_redraw()
