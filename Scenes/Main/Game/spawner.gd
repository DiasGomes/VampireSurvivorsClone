extends Node2D

@export var player:Player
@export var game:Game
@export var spawnerEnemy:PackedScene
@export var enemys:Array[EnemyDefinition]


func _ready() -> void:
	for enemy in enemys:
		var scene:SpawnerEnemy = spawnerEnemy.instantiate()
		scene.player = player
		scene.game = game
		scene.enemy_definition = enemy
		add_child(scene)
