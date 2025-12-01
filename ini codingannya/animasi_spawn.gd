extends CharacterBody2D
@onready var tengkorakPath = load("res://scene/tengkorak.tscn")
@onready var tanamanPath = load("res://scene/musuh_tanaman.tscn")
@onready var tengkorak_kuningPath = load("res://scene/tengkorak_kuning.tscn")
@onready var tengkorak_putihPath = load("res://scene/tengkorak_putih.tscn")
@onready var anim = $AnimationPlayer
var jenisMusuh = ["tengkorak", "tanaman", "tengkorak_kuning", "tengkorak_putih"]
var enemyPath
var enemy

func _ready() -> void:
	anim.play("spawn_animation")
	await anim.animation_finished
	spawn_enemy()

func spawn_enemy():
	enemyPath = jenisMusuh.pick_random()
	
	match enemyPath:
		"tengkorak" :
			enemy = tengkorakPath.instantiate()
		"tanaman" :
			enemy = tanamanPath.instantiate()
		"tengkorak_kuning":
			enemy = tengkorak_kuningPath.instantiate()
		"tengkorak_putih":
			enemy = tengkorak_putihPath.instantiate()
	
	
	
	get_parent().add_child(enemy)
	enemy.global_position = global_position
	enemy.scale = Vector2(2.1, 2.1)
	await get_tree().create_timer(0.5).timeout
	queue_free()
