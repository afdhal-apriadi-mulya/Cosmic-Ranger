extends Control

@onready var label = $CanvasLayer/PanelContainer/Label
@onready var animasiPlayer = $AnimationPlayer
@onready var kotakNama = $CanvasLayer/LabelOrang
@onready var labelNama = $CanvasLayer/LabelOrang/namaOrang
@onready var teksSFX = preload("res://src/audio/teksSFX.wav")

var tambahanKecepatan = 1
var bisa_pindah = false
var x = 1
var kordinat = {
	"kanan" : Vector2(832.0, 374.0),
	"kiri" : Vector2(31.0, 374.0)
}


var teks = {
	1: ""
}
var orang = {
	1 : ""
}
var kecepatan = 0.1


func _ready() -> void:
	get_tree().paused = true
	kotakNama.position = Vector2(432.0, 374.0)
	labelNama.text = orang[x]
	await animasiPlayer.animation_finished
	animasiTeks(teks, kecepatan)

func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_right") && bisa_pindah):
		x += 1
		if (x > teks.size()):
			hapus()
			return
		animasiTeks(teks, kecepatan)
	elif (Input.is_action_just_pressed("ui_left") && bisa_pindah):
		x -= 1
		if (x <= 0):
			hapus()
			return
		animasiTeks(teks, kecepatan)
	
	if (Input.is_action_pressed("ui_up")):
		tambahanKecepatan = 0.1
	else:
		tambahanKecepatan = 1
	
	if (Input.is_action_just_pressed("ui_cancel")):
		hapus()


func animasiTeks(teksInput, jedaPerHuruf):
	bisa_pindah = false
	var teks_saatIni = ""
	var teksDisplay = teksInput[x]
	
	labelNama.text = orang[x]
	animasiNama()
	print(x)
	
	for i in range(teksDisplay.length()):
		putarSFX(teksSFX)
		teks_saatIni += teksDisplay[teks_saatIni.length()]
		label.text = teks_saatIni
		await get_tree().create_timer(jedaPerHuruf * tambahanKecepatan).timeout
	
	bisa_pindah = true


func putarSFX(musikPath):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = musikPath
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)


func hapus():
	animasiPlayer.play_backwards("opening")
	await animasiPlayer.animation_finished
	get_tree().paused = false
	get_parent().sedangBicara = false
	queue_free()


func animasiNama():
	var posisiNama
	if (orang[x] == dataBase.characterTerpilih):
		posisiNama = kordinat["kiri"]
	else:
		posisiNama = kordinat["kanan"]
	var animasi = create_tween()
	animasi.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	animasi.tween_property(kotakNama, "position", posisiNama, 0.7)
