extends Node2D

@onready var peluru_src = preload("res://scene/peluru.tscn")
@onready var audioPath = preload("res://src/audio/shotgun.wav")

@onready var posisi1 = $Sprite2D/Marker2D1
@onready var posisi2 = $Sprite2D/Marker2D2
@onready var posisi3 = $Sprite2D/Marker2D3
@onready var posisi4 = $Sprite2D/Marker2D4
@onready var posisi5 = $Sprite2D/Marker2D5
var canAttack = true

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	 
	if(float(get_global_mouse_position().x) < float(global_position.x)):
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
	
		
	if (dataBase.senjataSaatIni != "shotgun"):
		queue_free()

func _process(_delta: float) -> void:
		if (Input.is_action_pressed("attack") && canAttack):
			spawnPeluru()
			putarSound()

	
func spawnPeluru():
	canAttack = false

	var peluru = peluru_src.instantiate()
	peluru.globalPos = posisi1.global_position
	peluru.pos_ujung = posisi1.global_position
	peluru.posisiPistol = $Sprite2D/posisiSenjata.global_position
	
	var peluru2 = peluru_src.instantiate()
	peluru2.globalPos = posisi2.global_position
	peluru2.pos_ujung = posisi2.global_position
	peluru2.posisiPistol = $Sprite2D/posisiSenjata.global_position
	
	var peluru3 = peluru_src.instantiate()
	peluru3.globalPos = posisi3.global_position
	peluru3.pos_ujung = posisi3.global_position
	peluru3.posisiPistol = $Sprite2D/posisiSenjata.global_position
	
	var peluru4 = peluru_src.instantiate()
	peluru4.globalPos = posisi4.global_position
	peluru4.pos_ujung = posisi4.global_position
	peluru4.posisiPistol = $Sprite2D/posisiSenjata.global_position
	
	var peluru5 = peluru_src.instantiate()
	peluru5.globalPos = posisi5.global_position
	peluru5.pos_ujung = posisi5.global_position
	peluru5.posisiPistol = $Sprite2D/posisiSenjata.global_position
	
	get_tree().root.add_child(peluru)
	get_tree().root.add_child(peluru5)
	get_tree().root.add_child(peluru2)
	get_tree().root.add_child(peluru3)
	get_tree().root.add_child(peluru4)
	await get_tree().create_timer(0.3).timeout
	canAttack = true


func putarSound():
	var audio = AudioStreamPlayer.new()
	audio.stream = audioPath
	audio.volume_db = 20.0
	add_child(audio)
	audio.play()
	audio.finished.connect(audio.queue_free)
