class_name SpawnSlime
extends Marker2D

@export var player:Player
@export var game:Game
@onready var enemy_spawner_component: SceneSpawner = $EnemySpawnerComponent
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var orbe_spawner_component: SceneSpawner = $OrbeSpawnerComponent

var lst_enemy:Array[Enemy]
var spawn_enemy_time:bool
var enemy_limit:int = 30
var radius:int = 500
var angle:float = 0


func _ready() -> void:
	spawn_enemy_time = true
	player.upgrade.connect(limit_increase)
	
	
func _physics_process(_delta: float) -> void:
	#draw_marker_2d()
	rotated_position_marker(_delta)
	if lst_enemy.size() < enemy_limit:
		if spawn_enemy_time:
			spawn_slime()
			
	for enemy in lst_enemy:
		enemy.target_position = player.position


func limit_increase(_level:int) -> void:
	enemy_limit = 30 + (10 * _level)
	

func rotated_position_marker(_delta: float) -> void: 
	position = player.position + Vector2(radius, 0).rotated(angle)
	angle += 1 * _delta
	if angle >= (2 * PI):
		angle = 0


func spawn_slime() -> void:
	var new_enemy:Enemy = enemy_spawner_component.spawn(game)
	new_enemy.start_slime(player.position)
	new_enemy.position = position
	new_enemy.died.connect(enemy_destroy)
	lst_enemy.append(new_enemy)
	spawn_enemy_time = false
	enemy_spawn_timer.start()
	
	
func spawn_orbe(_position:Vector2) -> void:
	var new_orbe:Orbe = orbe_spawner_component.spawn(game)
	new_orbe.position = _position
	

func enemy_destroy(_body:Enemy) -> void:
	spawn_orbe(_body.position)
	lst_enemy.erase(_body)

# funcoes de debug
func _draw() -> void:
	if Engine.is_editor_hint() or OS.is_debug_build():
		draw_line(Vector2(-10, 0), Vector2(10, 0), Color(1, 0, 0), 2)
		draw_line(Vector2(0, -10), Vector2(0, 10), Color(1, 0, 0), 2)
		draw_circle(Vector2.ZERO, 3, Color(0, 0, 1))

func draw_marker_2d() -> void:
	if Engine.is_editor_hint() or OS.is_debug_build():
		queue_redraw()


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy_time = true
