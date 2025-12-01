extends Control

@onready var TomKanan : Button = $Panel/Kanan
@onready var TomKiri : Button = $Panel/Kiri
@onready var TomStart : Button = $Panel/start
@onready var TomClose : Button = $Panel/close
@onready var sprite : AnimatedSprite2D = $Panel/AnimatedSprite2D
@onready var animasi : AnimationPlayer = $AnimationPlayer
@onready var namaHero = $Panel/LineEdit

var namaPlayer1 = dataBase.namaPlayer[1]
var namaPlayer2 = dataBase.namaPlayer[2]

#var kumpulanCharacter = [namaPlayer1, namaPlayer2]
var indexCharacter = 0

func _ready() -> void:
	get_parent().fokusDisable = true
	sprite.play("player" + str(indexCharacter + 1))
	animasi.play("opening")
	get_parent().popUp = true
	dataBase.mode = "normal"
	dataBase.characterTerpilih = dataBase.namaPlayer[indexCharacter + 1]
	namaHero.text = dataBase.namaPlayer[indexCharacter + 1]
	#penyesuaianHero()
	

func _physics_process(_delta: float) -> void:
	namaPlayer1 = dataBase.namaPlayer[1]
	namaPlayer2 = dataBase.namaPlayer[2]
	
	if sprite.animation == "player1":
		sprite.scale = Vector2(8.0, 8.0)
	elif sprite.animation == "player2":
		sprite.scale = Vector2(12.5, 12.5)




func _on_kanan_pressed() -> void:
	get_parent().putarSFX(get_parent().pressedPath)
	dataBase.namaPlayer[indexCharacter + 1] = namaHero.text
	
	if (indexCharacter >= dataBase.namaPlayer.size() - 1):
		indexCharacter = -1
	indexCharacter += 1
	sprite.play("player" + str(indexCharacter + 1))
	namaHero.text = dataBase.namaPlayer[indexCharacter + 1]
	dataBase.characterTerpilih = dataBase.namaPlayer[indexCharacter + 1]


func _on_kiri_pressed() -> void:
	get_parent().putarSFX(get_parent().pressedPath)
	dataBase.namaPlayer[indexCharacter + 1] = namaHero.text
	
	if (indexCharacter <= 0):
		indexCharacter = dataBase.namaPlayer.size()
	indexCharacter -= 1
	sprite.play("player" + str(indexCharacter + 1))
	namaHero.text = dataBase.namaPlayer[indexCharacter + 1]
	dataBase.characterTerpilih = dataBase.namaPlayer[indexCharacter + 1]


func _on_start_pressed() -> void:
	get_parent().putarSFX(get_parent().pressedPath)
	dataBase.namaPlayer[indexCharacter + 1] = namaHero.text
	dataBase.characterTerpilih = dataBase.namaPlayer[indexCharacter + 1]
	TomStart.add_theme_color_override("font_hover_color", Color())
	get_parent().animasiModulate()
	await get_tree().create_timer(0.49).timeout
	get_tree().change_scene_to_file("res://scene/world.tscn")
	pass # Replace with function body.


func _on_close_pressed() -> void:
	get_parent().putarSFX(get_parent().pressedPath)
	animasi.play("close")
	await animasi.animation_finished
	get_parent().popUp = false
	get_parent().fokusDisable = false
	get_parent().sembunyikanLatar(false)
	queue_free()
	pass # Replace with function body.


func _on_option_button_item_selected(index: int) -> void:
	if (index == 0):
		dataBase.mode = "easy"
	elif (index == 1):
		dataBase.mode = "normal"
	elif (index == 2):
		dataBase.mode = "hard"
	elif (index == 3):
		dataBase.mode = "extream"


func _on_line_edit_text_submitted(new_text: String) -> void:
	dataBase.namaPlayer[indexCharacter + 1] = new_text
	namaHero.text = dataBase.namaPlayer[indexCharacter + 1]
	dataBase.characterTerpilih = dataBase.namaPlayer[indexCharacter + 1]
	dataBase.saveData()
