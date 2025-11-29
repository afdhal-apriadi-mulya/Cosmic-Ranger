extends Control

@onready var label : Label = $CanvasLayer/PanelContainer/Label
@onready var inputTeks : LineEdit = $CanvasLayer/PanelContainer/LineEdit
@onready var animasiPlayer : AnimationPlayer = $AnimationPlayer
@onready var teksPeringatan : Label = $CanvasLayer/PanelContainer/LabelPwSalah
@onready var videoPlayer : VideoStreamPlayer = $CanvasLayer/PanelContainer/VideoStreamPlayer
@onready var peringatanSFX = preload("res://src/audio/peringatan_SFX.wav")


func _ready() -> void:
	teksPeringatan.hide()

func _on_oke_btn_pressed() -> void:
	if (inputTeks.text == dataBase.password):
		animasiPlayer.play("perluasArea")
		await animasiPlayer.animation_finished
		videoPlayer.play()
		await videoPlayer.finished
		animasiPlayer.play_backwards("perluasArea")
		await animasiPlayer.animation_finished
		animasiPlayer.play_backwards("opening")
		await animasiPlayer.animation_finished
		get_parent().sembunyikanLatar(false)
		get_parent().popUp = false
		queue_free()
	else:
		inputTeks.text = ""
		teksPeringatan.show()
		putarSFX(peringatanSFX)


func _on_close_pressed() -> void:
	animasiPlayer.play_backwards("opening")
	await animasiPlayer.animation_finished
	get_parent().popUp = false
	get_parent().sembunyikanLatar(false)
	queue_free()


func _on_line_edit_text_changed(_new_text: String) -> void:
	teksPeringatan.hide()

func putarSFX(sound):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)
