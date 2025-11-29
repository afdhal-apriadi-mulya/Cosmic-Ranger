extends Node2D

var lokasiFile = "user://saveGameCosmicRanger-ByCEES.dat"

var Global_posisiPlayer
var senjataSaatIni = "null"
var player_dead = false
var player_kebal = false
var score = 0
var totalMusuh = 50
var kill = 0

var damageTengkorak
var damageTanaman = 20
var darahTengkorak 
var darahTanaman = 80
var damageTengkorak_putih
var darahTengkorak_putih
var damageTengkorak_kuning
var darahTengkorak_kuning

var koin = 0
var max_nyawa_P1 = 100
var hightScore = 0
var kecepatanPlayer = 300.0
var nyawa_P1 = 100
var characterTerpilih = "null"
var posisiPeti
var posisi_displayPeti
var is_in_Game
var password = "GAME_CEES_GG"
var jumlahMenang = 0
var mode = "normal"
var namaPlayer = {
	1 : "Afdhal",
	2 : "Cassev"
}
var luasMap = [200, 3500, 3500, 200]


signal updateDataStore(jenisData : String, nilai)
signal ulangPermainan()

func _ready() -> void:
	loadData()
	get_tree().paused = false
	


func saveData():
	var data = {
		"hightScore" : hightScore,
		"koin" : koin,
		"kecepatanPlayer" : kecepatanPlayer,
		"max_nyawa" : max_nyawa_P1,
		"namaPlayer" : namaPlayer,
		"jumlahMenang" : jumlahMenang
	}
	
	var file = FileAccess.open_encrypted_with_pass(lokasiFile, FileAccess.WRITE, "awokwok")
	file.store_var(data)
	file.close()

func loadData():
	if !FileAccess.file_exists(lokasiFile):
		print("tidak ada data / null")
		return
	
	var file = FileAccess.open_encrypted_with_pass(lokasiFile, FileAccess.READ, "awokwok")
	var data = file.get_var()
	hightScore = data["hightScore"]
	koin = data["koin"]
	kecepatanPlayer = data["kecepatanPlayer"]
	max_nyawa_P1 = data["max_nyawa"]
	namaPlayer = data["namaPlayer"]
	jumlahMenang = data["jumlahMenang"]
	print("ada data")
	print (data["hightScore"])
	print (data["koin"])
	file.close()
