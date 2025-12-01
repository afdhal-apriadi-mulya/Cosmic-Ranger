extends Node2D
@onready var animasiPath = load("res://scene/animasi_spawn.tscn")
#@onready var spawn_point = $"spawn_point".get_children()
var posisi
var jumlahMusuhDiSpawn = 0

func _ready() -> void:
	$Timer.wait_time = 1

func _on_timer_timeout() -> void:
	#posisi = spawn_point.pick_random()
	if (jumlahMusuhDiSpawn >= dataBase.totalMusuh):
		return
	
	var posisi_X = randf_range(0, dataBase.luasMap[1])
	var posisi_Y = randf_range(0, dataBase.luasMap[2])
	posisi = Vector2(posisi_X, posisi_Y)
	
	var animasi = animasiPath.instantiate()
	add_child(animasi)
	animasi.global_position = posisi
	
	jumlahMusuhDiSpawn += 1
	
