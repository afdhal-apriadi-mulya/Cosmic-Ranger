extends Control

@onready var scenePemilihanCharacter = preload("res://scene/pemilihan_hero.tscn")
@onready var sceneStore = load("res://scene/store.tscn")
@onready var tombolStart : Button = $VBoxContainer/start
@onready var tombolStore : Button = $VBoxContainer/store
@onready var tombolOurProfil : Button = $VBoxContainer/our_profil
@onready var animasi : AnimationPlayer = $AnimationPlayer
@onready var animasi_preselect : AnimationPlayer = $AnimationPlayer_preselect
@onready var panah : Control = $panah_preselect
@onready var timer : Timer = $Timer
@onready var pressedPath = preload("res://src/audio/tombolDitekan_SFX.WAV")
@onready var hoverPath = preload("res://src/audio/tombolDipilih_SFX.WAV")
@onready var easterEggPath = preload("res://scene/easter_egg.tscn")

var popUp = false
var fokusDisable = false
var modePreselect = false
var posisiPanah
var posisiTomStart
var posisiTomStore
var posisiTomOurProfil
var jumlahKlik= 0 

func _ready() -> void:
	get_tree().paused = false
	panah.hide()
	dataBase.is_in_Game = false

#func _physics_process(_delta: float) -> void:
	#if fokusDisable:
		#tombolStart.focus_mode = Control.FOCUS_NONE
		#tombolStore.focus_mode = Control.FOCUS_NONE
		#tombolOurProfil.focus_mode = Control.FOCUS_NONE
	#else:
		#tombolStart.focus_mode = Control.FOCUS_ALL
		#tombolStore.focus_mode = Control.FOCUS_ALL
		#tombolStore.focus_mode = Control.FOCUS_ALL
	
	mode_PreSelect()


func mode_PreSelect():
	if (Input.is_action_just_pressed("ui_accept")):
		if (tombolStart.has_focus()):
			_on_start_pressed()
		elif (tombolStore.has_focus()):
			_on_store_pressed()
		elif (tombolOurProfil.has_focus()):
			_on_our_profil_pressed()


func _on_start_pressed() -> void:
	if popUp:
		return
	popUp = true
	sembunyikanLatar(true)
	putarSFX(pressedPath)
	var pemilihan = scenePemilihanCharacter.instantiate()
	add_child(pemilihan)


func _on_store_pressed() -> void:
	if popUp:
		return
	popUp = true
	sembunyikanLatar(true)
	var store = sceneStore.instantiate()
	add_child(store)
	putarSFX(pressedPath)


func _on_our_profil_pressed() -> void:
	if popUp:
		return
	animasi.play("modulate")
	await animasi.animation_finished
	get_tree().change_scene_to_file("res://scene/our_profil.tscn")
	
	putarSFX(pressedPath)


func animasiModulate():
	animasi.play("modulate")
	await animasi.animation_finished

func putarSFX(jenis):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = jenis
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)


func _on_start_focus_entered() -> void:
	panah.show()
	posisiPanah = panah.get_screen_position()
	posisiTomStart = tombolStart.get_screen_position()
	var arah = posisiTomStart - posisiPanah
	panah.position.y += arah.y - 280
	putarSFX(hoverPath)


func _on_store_focus_entered() -> void:
	panah.show()
	posisiPanah = panah.get_screen_position()
	posisiTomStore = tombolStore.get_screen_position()
	var arah = posisiTomStore - posisiPanah
	panah.position.y += arah.y - 280
	putarSFX(hoverPath)


func _on_our_profil_focus_entered() -> void:
	panah.show()
	posisiPanah = panah.get_screen_position()
	posisiTomOurProfil = tombolOurProfil.get_screen_position()
	var arah = posisiTomOurProfil - posisiPanah
	panah.position.y += arah.y - 280
	putarSFX(hoverPath)


func sembunyikanLatar(nilai : bool):
	$VBoxContainer.visible = !nilai
	$Label.visible = !nilai
	panah.visible = false


func _on_tombol_easter_egg_pressed() -> void:
	jumlahKlik += 1
	print ("jumlah klik: " + str(jumlahKlik))
	timer.stop()
	timer.start(0.4)


func _on_timer_timeout() -> void:
	print ("timer timeout")
	if (jumlahKlik == 5):
		popUp = true
		var easterEgg = easterEggPath.instantiate()
		add_child(easterEgg)
		sembunyikanLatar(true)
	elif (jumlahKlik > 5):
		print ("kelebihan klik")
	jumlahKlik = 0
