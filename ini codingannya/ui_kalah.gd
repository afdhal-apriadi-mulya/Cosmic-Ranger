extends Control

@onready var respawnBtn : Button = $CanvasLayer/PanelContainer/RespawnBtn
@onready var tryAgainBtn : Button = $CanvasLayer/PanelContainer/Container/tryAgainBtn
@onready var mainMenuBtn : Button= $CanvasLayer/PanelContainer/Container/mainMenuBtn
@onready var labelScore : Label = $CanvasLayer/PanelContainer/NilaiScore
@onready var labelHighscore : Label = $CanvasLayer/PanelContainer/NilaiHightScore
@onready var labelSelamat : Label = $CanvasLayer/PanelContainer/LabelSelamat
@onready var animasiPlayer : AnimationPlayer = $AnimationPlayer
@onready var teks_SistemPath = load("res://scene/teks_Sistem.tscn")
@onready var peringatanSFX = preload("res://src/audio/peringatan_SFX.wav")
@onready var buySFX = preload("res://src/audio/buy1.wav")

var highscoreLama
var scoreDisplay = 0
var hargaRespawn = 250
var kondisi

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	labelHighscore.text = str(dataBase.hightScore)
	if (dataBase.mode == "hard") || (dataBase.mode == "extream"):
		respawnBtn.hide()
	else:
		respawnBtn.show()
	if (dataBase.mode == "easy"):
		hargaRespawn = 250
	elif  (dataBase.mode == "normal"):
		hargaRespawn = 500
	respawnBtn.text = "REVIVE $" + str(hargaRespawn)
	
	if (dataBase.score > dataBase.hightScore):
		dataBase.hightScore = dataBase.score
		dataBase.saveData()
	
	if (dataBase.score > highscoreLama):
		animasiPlayer.play("highScore")
		kondisi = "highScore"
	else:
		animasiPlayer.play("ScoreBiasa")
		labelScore.text = "0"
		kondisi = "ScoreBiasa"
		await get_tree().create_timer(0.8).timeout

func _physics_process(_delta: float) -> void:
	if (scoreDisplay < dataBase.score):
		animasiScore(0.1)


func animasiScore(kecepatan):
	if (scoreDisplay >= dataBase.score):
		labelScore.text = str(dataBase.score)
		return
	
	scoreDisplay += 1
	labelScore.text = str(scoreDisplay)
	print (labelScore.text)
	await get_tree().create_timer(kecepatan).timeout




func _on_tryAgain_btn_pressed() -> void:
	dataBase.score = 0
	get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_main_menu_btn_pressed() -> void:
	dataBase.score = 0
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn")


func _on_respawn_btn_pressed() -> void:
	if (dataBase.koin < hargaRespawn):
		displayTeks("koin tidak cukup, Anda harus mengulang permainan !!!")
		putarSFX(peringatanSFX)
		return
	
	dataBase.koin -= hargaRespawn
	dataBase.saveData()
	putarSFX(buySFX)
	animasiPlayer.play_backwards(kondisi)
	await animasiPlayer.animation_finished
	get_tree().paused = false
	dataBase.ulangPermainan.emit()
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
