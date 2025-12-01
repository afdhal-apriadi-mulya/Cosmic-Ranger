extends PanelContainer

@onready var label = $HBoxContainer/Label
@onready var soundPath = preload("res://src/audio/buy2.wav")

var koinDisplay
var kecepatan = 0.4
var bisaPutarSFX = true

func _ready() -> void:
	koinDisplay = dataBase.koin

func _physics_process(_delta: float) -> void:
	label.text = str(koinDisplay)
	updateDisplayKoin()
	updateCheatKoin()


func updateDisplayKoin():
	if (koinDisplay > dataBase.koin):
		koinDisplay -= 1
		await get_tree().create_timer(kecepatan).timeout
	if (koinDisplay < dataBase.koin):
		koinDisplay += 1
		putarSFX(soundPath, true)
		await get_tree().create_timer(kecepatan).timeout

func updateCheatKoin():
	
	if (Input.is_action_pressed("cheat") && (Input.is_action_just_pressed("k")) && (dataBase.mode != "hard" && dataBase.mode != "extream")):
		print (dataBase.mode)
		dataBase.koin += 30

func putarSFX(sound, jedaGak):
		if !bisaPutarSFX:
			return
		bisaPutarSFX = false
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.stream = sound
		add_child(audioPlayer)
		audioPlayer.play()
		if jedaGak:
			await get_tree().create_timer(0.6).timeout
		audioPlayer.finished.connect(audioPlayer.queue_free)
		bisaPutarSFX = true
