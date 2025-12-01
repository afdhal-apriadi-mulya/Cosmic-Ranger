extends Control

@onready var animasi = $AnimationPlayer
@onready var buyKecepatan = $CanvasLayer/PanelContainer/kecepatan/kecepatanBtn
@onready var buyDarah = $CanvasLayer/PanelContainer/darah/darahBtn
@onready var buyMaxDarah = $"CanvasLayer/PanelContainer/max darah/maxDarahBtn"
@onready var teks_SistemPath = load("res://scene/teks_Sistem.tscn")
@onready var buySFX = preload("res://src/audio/buy1.wav")
@onready var peringatanSFX = preload("res://src/audio/peringatan_SFX.wav")
@onready var tombolKlikSFX = preload("res://src/audio/tombolDitekan_SFX.WAV")

var hargaKecepatan = 100
var hargaDarah = 20
var hargaMaxDarah = 50

var nilaiKecepatan = 10
var nilaiDarah = 20
var nilaiMaxDarah = 10


func _ready() -> void:
	if (dataBase.is_in_Game):
		get_tree().paused = true
		$CanvasLayer/PanelContainer/PanelContainer.hide()
	else:
		$CanvasLayer/PanelContainer/PanelContainer.show()
	buyKecepatan.text = "$" + str(hargaKecepatan)
	buyDarah.text = "$" + str(hargaDarah)
	buyMaxDarah.text = "$" + str(hargaMaxDarah)
	animasi.play("opening")

func _on_kecepatan_btn_pressed() -> void:
	if dataBase.koin < hargaKecepatan:
		displayTeks("koin tidak cukup, farming sana !!!")
		putarSFX(peringatanSFX)
		return
	
	dataBase.kecepatanPlayer += nilaiKecepatan
	dataBase.updateDataStore.emit("kecepatan", nilaiKecepatan)
	dataBase.koin -= hargaKecepatan
	dataBase.saveData()
	putarSFX(buySFX)
	displayTeks("kecepatan telah bertambah " + str(nilaiKecepatan))

func _on_darah_btn_pressed() -> void:
	if dataBase.koin < hargaDarah:
		displayTeks("koin tidak cukup, farming sana !!!")
		putarSFX(peringatanSFX)
		return
	if dataBase.is_in_Game == false:
		putarSFX(peringatanSFX)
		displayTeks("Maaf, Item ini hanya bisa dibeli pada saat pertempuran")
		return
	if (dataBase.nyawa_P1 == dataBase.max_nyawa_P1):
		putarSFX(peringatanSFX)
		displayTeks("woilahh, darah dah penuh ngapain isi darah lagi *_*")
		return
	
	dataBase.nyawa_P1 += nilaiDarah
	if (dataBase.nyawa_P1 > dataBase.max_nyawa_P1):
		dataBase.nyawa_P1 = dataBase.max_nyawa_P1
	dataBase.updateDataStore.emit("nyawa", nilaiDarah)
	dataBase.koin -= hargaDarah
	dataBase.saveData()
	putarSFX(buySFX)
	displayTeks("darah player telah bertambah " + str(nilaiDarah))

func _on_max_darah_btn_pressed() -> void:
	if dataBase.koin < hargaMaxDarah:
		displayTeks("koin tidak cukup, farming sana !!!")
		putarSFX(peringatanSFX)
		return
	
	dataBase.max_nyawa_P1 += nilaiMaxDarah
	dataBase.nyawa_P1 += nilaiMaxDarah
	dataBase.updateDataStore.emit("maxDarah", nilaiMaxDarah)
	dataBase.koin -= hargaMaxDarah
	dataBase.saveData()
	putarSFX(buySFX)
	displayTeks("maximal darah telah bertambah " + str(nilaiMaxDarah))


func _on_close_pressed() -> void:
	putarSFX(tombolKlikSFX)
	animasi.play_backwards("opening")
	await animasi.animation_finished
	if (!dataBase.is_in_Game):	
		get_parent().sembunyikanLatar(false)
		get_parent().popUp = false
	else:
		get_tree().paused = false
	queue_free()


func displayTeks(isi_teks):
	var teks = teks_SistemPath.instantiate()
	teks.type = "teks notif"
	teks.inputTeks = isi_teks
	
	get_parent().add_child(teks)

func putarSFX(soundPath):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = soundPath
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)
