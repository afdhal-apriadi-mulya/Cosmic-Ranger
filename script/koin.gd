extends Node2D

@onready var koin = $CharacterBody2D
@onready var koin_SFX = load("res://src/audio/koin.wav")
var telahDiambil = false
var diambilOtomatis = false
var kecepatan = 400
var nodeKoin
var nodeKamera


func _ready() -> void:
	nodeKoin = get_tree().get_first_node_in_group("koin")
	nodeKamera = get_tree().get_first_node_in_group("kamera")
	autoAmbil()




func _physics_process(_delta: float) -> void:
	kumpulkanKoin()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player_hitBox")) && telahDiambil == false:
		print("kena koin")
		telahDiambil = true
		var audio = AudioStreamPlayer.new()
		audio.stream = koin_SFX
		add_child(audio)
		audio.play()


func kumpulkanKoin():
	if !telahDiambil:
		return
	if not nodeKoin or not nodeKamera:
		return
	
	var posisiDisplay = nodeKoin.global_position
	var posisiTujuan = nodeKamera.get_viewport().get_canvas_transform().affine_inverse() * posisiDisplay
	var arah = posisiTujuan - koin.global_position
	koin.velocity = arah.normalized() * kecepatan
	koin.move_and_slide()
	
	var jarak = koin.global_position.distance_to(posisiTujuan)
	if jarak < 5:
		masukPeti()

func autoAmbil():
	await get_tree().create_timer(10).timeout
	if telahDiambil:
		return
	if (telahDiambil == false):
		telahDiambil = true
		diambilOtomatis = true


func masukPeti():
	print("fucn masuk peti")
	dataBase.koin += 1
	queue_free()
