extends Node2D

@onready var peluru_src = preload("res://scene/peluru.tscn")
@onready var audioPath = preload("res://src/audio/doublePistol.wav")
@onready var posisi = $Sprite2D/Marker2D
@onready var posisiPistol : Marker2D = $Sprite2D/posisiPistol
var canAttack = true

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	 
	if(float(get_global_mouse_position().x) < float(global_position.x)):
		$Sprite2D.flip_v = true
		posisi.position.y *= -1
	else:
		$Sprite2D.flip_v = false
		posisi.position.y *= 1
	
		
	if (dataBase.senjataSaatIni != "doublePistol"):
		queue_free()

func _process(_delta: float) -> void:
		if (Input.is_action_pressed("attack") && canAttack):
			spawnPeluru()

	
func spawnPeluru():
	canAttack = false
	putarSound()
	var peluru = peluru_src.instantiate()
	peluru.globalPos = posisi.global_position
	peluru.posisiPistol = $Sprite2D/posisiPistol.global_position
	peluru.pos_ujung = posisi.global_position
	get_tree().root.add_child(peluru)
	await get_tree().create_timer(0.3).timeout
	canAttack = true

func putarSound():
	var audio = AudioStreamPlayer.new()
	audio.stream = audioPath
	add_child(audio)
	audio.play()
	audio.finished.connect(audio.queue_free)
