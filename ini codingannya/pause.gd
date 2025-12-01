extends Node

@onready var animasi = $AnimationPlayer
@onready var UI_PauseMenu = $PanelContainer
@onready var UI_PauseBtn = $Button/TextureRect
@onready var pause_TeksturPath = preload("res://src/img/ui/pauseBtn2.png")
@onready var resume_TeksturPath = preload("res://src/img/ui/resumeBtn.png")
@onready var tombol_diKlikPath = preload("res://src/audio/tombolDitekan_SFX.WAV")

func _ready() -> void:
	UI_PauseMenu.hide()
	get_tree().paused = false
	UI_PauseBtn.texture = pause_TeksturPath
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("ui_cancel")):
		update_pause_UI(!get_tree().paused)

func update_pause_UI(is_pause : bool):
		print(get_tree().paused)
		if (is_pause == false):
			UI_PauseBtn.texture = pause_TeksturPath
			animasi.play_backwards("opening")
			await animasi.animation_finished
			UI_PauseMenu.hide()
			get_tree().paused = false
			print ("game dimulai")
		elif (is_pause == true):
			UI_PauseBtn.texture = resume_TeksturPath
			UI_PauseMenu.show()
			animasi.play("opening")
			get_tree().paused = true
			print ("game dipause")


func _on_resume_btn_pressed() -> void:
	update_pause_UI(false)
	putarSFX(tombol_diKlikPath)


func _on_main_menu_btn_pressed() -> void:
	dataBase.saveData()
	putarSFX(tombol_diKlikPath)
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn")


func _on_pauseButton_pressed() -> void:
	update_pause_UI(!get_tree().paused)


func putarSFX(musikApa):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = musikApa
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)
