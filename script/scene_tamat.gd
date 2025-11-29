extends Control

@onready var canvasModulate : CanvasModulate = $CanvasLayer/CanvasModulate
@onready var label : Label = $CanvasLayer/LabelTamat
@onready var animasiPlayer : AnimationPlayer = $AnimationPlayer
@onready var labelEasterEgg : Label = $CanvasLayer/LabelEasterEgg
@onready var teksSFX = preload("res://src/audio/teksKlik_SFX.wav")

var password = dataBase.password

func _ready() -> void:
	label.hide()
	labelEasterEgg.hide()
	animasiTeksTamat("TAMAT", 0.3)
	await  get_tree().create_timer(4).timeout
	animasiPlayer.play("TAMAT")
	await animasiPlayer.animation_finished
	labelEasterEgg.show()
	animasiTeksEasterEgg("EASTER EGG", 2.5, "\nKlik bulan pada mainMenu sebanyak 5X berturut-turut", "\n\nPASSWORD\n" + str(password), 1.5, 0.2)
	await get_tree().create_timer(25).timeout
	animasiPlayer.play("close")
	dataBase.jumlahMenang += 1
	dataBase.saveData()
	await animasiPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn")



func animasiTeksTamat(teksInput, jedaPerHuruf):
	label.show()
	var teks_saatIni = ""
	label.text = teks_saatIni
	
	for i in range(teksInput.length()):
		putarSFX(teksSFX)
		teks_saatIni += teksInput[teks_saatIni.length()]
		label.text = teks_saatIni
		await get_tree().create_timer(jedaPerHuruf).timeout

func animasiTeksEasterEgg(judul, lamaJudul, teksInput, teksInput2, jedaTeksInput2, jedaPerHuruf):
	labelEasterEgg.show()
	labelEasterEgg.text = ""
	
	for i in range(judul.length()):
		putarSFX(teksSFX)
		labelEasterEgg.text += judul[i]
		await get_tree().create_timer(jedaPerHuruf).timeout
	await get_tree().create_timer(lamaJudul).timeout
	for i in range(teksInput.length()):
		putarSFX(teksSFX)
		labelEasterEgg.text += teksInput[i]
		await get_tree().create_timer(jedaPerHuruf).timeout
	await get_tree().create_timer(jedaTeksInput2).timeout
	for i in range(teksInput2.length()):
		putarSFX(teksSFX)
		labelEasterEgg.text += teksInput2[i]
		await get_tree().create_timer(jedaPerHuruf).timeout


func putarSFX(musikPath):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = musikPath
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)
	
