class_name Player
extends Entity

signal upgrade

@onready var state_machine: NodeStateMachine = $StateMachine
@onready var idle: Node = $StateMachine/Idle
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

var level:int
var xp:int
var xp_level:Array[int]

func new_game() -> void:
	state_machine.initial_node_state = idle
	level = 0
	xp = 0
	xp_level = [10,20,30,40,50,60,70,80,90,100]
	progress_bar.max_value = xp_level[level]
	start()


func _process(_delta: float) -> void:
	#print(str(xp) + "/" + str(xp_level[level]))
	progress_bar.value = xp
	level_up()


func add_score() -> void:
	xp+=1


func level_up() -> void:
	if xp >= xp_level[level]:
		xp = xp - xp_level[level]
		level += 1
		progress_bar.max_value = xp_level[level]
		upgrade.emit(level)
		if level >= xp_level.size():
			print("Venceu!!!")
			new_game()


func move_input() -> void:
	# movimento horizontal
	if Input.is_action_pressed("Right"):
		my_direction.x = 1
		my_sprites.flip_h = false
	elif Input.is_action_pressed("Left"):
		my_direction.x = -1
		my_sprites.flip_h = true
	else:
		my_direction.x = 0
	# movimento vertical
	if Input.is_action_pressed("Down"):
		my_direction.y = 1
	elif Input.is_action_pressed("Up"):
		my_direction.y = -1
	else:
		my_direction.y = 0
	# se nao estiver parado
	my_is_moving = true
	if my_direction == Vector2.ZERO:
		my_is_moving = false
