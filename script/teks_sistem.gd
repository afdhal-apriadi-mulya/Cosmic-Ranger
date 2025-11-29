extends Control

@onready var label = $CanvasLayer2/CenterContainer/Label
@onready var panelData = $"CanvasLayer/Status Data"
@onready var label_statsData = $"CanvasLayer/Status Data/labelData"
@onready var animasi = $AnimationPlayer
var type = "Status Data"
var inputTeks = "Game CEES"

func _ready() -> void:
	panelData.hide()
	label.hide()
	if (type == "teks notif"):
		teksNotif()
	else:
		tampilanData()
	#elif (type == )

func _physics_process(_delta: float) -> void:
	if (type == "Status Data"):
		if (Input.is_action_just_pressed("showStats")):
			panelData.visible = !panelData.visible
		tampilanData()

func teksNotif():
	label.text = inputTeks
	label.show()
	
	animasi.play("opening_notifikasi")
	await get_tree().create_timer(2).timeout
	animasi.play("tutup_notifikasi")
	await animasi.animation_finished
	queue_free()


func tampilanData():
	label_statsData.text = " STATUS: \n=> Nyawa: " + str(dataBase.nyawa_P1) + "\n=> MAX Nyawa: " + str(dataBase.max_nyawa_P1) + "\n=> Kecepatan: " + str(dataBase.kecepatanPlayer) + "\n=> Senjata: " + dataBase.senjataSaatIni + "\n=> is_kebal: " + str(dataBase.player_kebal) + "\n=> kill: " + str(dataBase.kill) + "\n=> is_dead: " + str(dataBase.player_dead) + "\n=> Karakter: " + dataBase.characterTerpilih + "\n=> is_in_game: " + str(dataBase.is_in_Game) + "\n=> Mode: " + str(dataBase.mode) 
