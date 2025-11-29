extends Node2D

@onready var player1 = load("res://scene/player1.tscn")
@onready var player2 = load("res://scene/player2.tscn")
@onready var zonaAmanPath =load("res://scene/zona_aman.tscn")
var character

func _ready() -> void:
	if (dataBase.characterTerpilih == dataBase.namaPlayer[1]):
		character = player1.instantiate()
	elif (dataBase.characterTerpilih == dataBase.namaPlayer[2]):
		character = player2.instantiate()
	
	add_child(character)
	character.global_position = Vector2(123.0, 154.0)
	
	if (dataBase.mode == "easy"):
		var zonaAman = zonaAmanPath.instantiate()
		zonaAman.global_position = Vector2(1485.0, 515.0)
		add_child(zonaAman)
		dataBase.damageTengkorak = 15
		dataBase.damageTanaman = 20
		dataBase.darahTengkorak = 100
		dataBase.darahTanaman = 80
		dataBase.totalMusuh = 100
		dataBase.damageTengkorak_putih = 25
		dataBase.darahTengkorak_putih = 120
		dataBase.damageTengkorak_kuning = 22
		dataBase.darahTengkorak_kuning = 110
		
		
	elif (dataBase.mode == "normal"):
		dataBase.damageTengkorak = 20
		dataBase.damageTanaman = 25
		dataBase.darahTengkorak = 110
		dataBase.darahTanaman = 100
		dataBase.totalMusuh = 200
		dataBase.damageTengkorak_putih = 30
		dataBase.darahTengkorak_putih = 140
		dataBase.damageTengkorak_kuning = 25
		dataBase.darahTengkorak_kuning = 120
		
	elif (dataBase.mode == "hard"):
		dataBase.damageTengkorak = 25
		dataBase.damageTanaman = 30
		dataBase.darahTengkorak = 125
		dataBase.darahTanaman = 110
		dataBase.totalMusuh = 300
		dataBase.damageTengkorak_putih = 35
		dataBase.darahTengkorak_putih = 140
		dataBase.damageTengkorak_kuning = 30
		dataBase.darahTengkorak_kuning = 120
		
	elif (dataBase.mode == "extream"):
		dataBase.damageTengkorak = 35
		dataBase.damageTanaman = 45
		dataBase.darahTengkorak = 150
		dataBase.darahTanaman = 120
		dataBase.totalMusuh = 400
		dataBase.damageTengkorak_putih = 50
		dataBase.darahTengkorak_putih = 150
		dataBase.damageTengkorak_kuning = 40
		dataBase.darahTengkorak_kuning = 140
	
	dataBase.is_in_Game = true
