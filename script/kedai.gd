extends Node2D

@onready var storePath = load("res://scene/store.tscn")
@onready var dialogicPath = load("res://scene/interaksi.tscn")
@onready var speechBubble = $penjual/speechBuble

var dalamAreaInteraksi
var jumlahInteraksi = 0
var sedangBicara = false
var nama = "Alif"
var namaPanggilan = "lip"

var jumlahObrolan = 5
var kecepatanObrolan = 0.07
var teksObrolan1 = {
	1 : "Lohh... " + str(dataBase.characterTerpilih) + " baru pulang " + str(namaPanggilan),
	2 : "Hehehe... iya",
	3 : "Tapi... bumi kan lagi ada masalah nih.. kok masih buka " + str(namaPanggilan) + "?", 
	4 : "Harus dong... Walaupun bumi lagi kacau sekalipn, pendapatan harus tetap jalan dong...",
	5 : "bumi kritis, ekonomi sulit -_-",
	6 : "gak bayangkan tuh? nanti diserang lohh...",
	7 : "tenang... gua kan mantan top global valo...",
	8 : "gak bakal ada yang berani mendekati toko ku",
	9 : "kek nya..., aku mau keliling dulu " + str(namaPanggilan),
	10 : "Lanjut broo... gua mau ngopi sambil ngelive, hahaha...."
}
var orang1 = {
	1 : nama,
	2 : str(dataBase.characterTerpilih),
	3 : str(dataBase.characterTerpilih),
	4 : nama,
	5 : nama,
	6 : str(dataBase.characterTerpilih),
	7 : nama,
	8 : nama,
	9 : str(dataBase.characterTerpilih),
	10 : nama
}

var teksObrolan2 = {
	1 : "Ayo beli beli..., disini lengkap semua",
	2 : "darah segar ada.., ramuan kecepatan pun ada...,",
	3 : "mau beli apa??",
	4 : "Mau liat-liat aja, Hehehe...."
}
var orang2 = {
	1 : nama,
	2 : nama,
	3 : nama,
	4 : dataBase.characterTerpilih
}

var dataTeksPercakapan = {
	1 : teksObrolan1,
	2 : teksObrolan2
}
var dataOrang = {
	1 : orang1,
	2 : orang2
}

func _ready() -> void:
	speechBubble.hide()

func _physics_process(_delta: float) -> void:
	if ((Input.is_action_just_pressed("i")) && dalamAreaInteraksi) && !sedangBicara:
		sedangBicara = true
		jumlahInteraksi += 1
		
		var dialoc = dialogicPath.instantiate()
		dialoc.kecepatan = kecepatanObrolan
		if (jumlahInteraksi > dataTeksPercakapan.size()):
			dialoc.teks = dataTeksPercakapan[dataTeksPercakapan.size()]
			dialoc.orang = dataOrang[dataTeksPercakapan.size()]
		else:
			dialoc.teks = dataTeksPercakapan[jumlahInteraksi]
			dialoc.orang = dataOrang[jumlahInteraksi]
		
		add_child(dialoc)
		


func _on_area_interaksi_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		print ("player mau belanja")
		var store = storePath.instantiate()
		add_child(store)

func _on_area_Interaksi_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		dalamAreaInteraksi = true
		speechBubble.show()




func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		dalamAreaInteraksi = false
		speechBubble.hide()
