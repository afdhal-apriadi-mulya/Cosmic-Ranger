extends Node2D

@onready var sceneDialog = load("res://scene/interaksi.tscn")
@onready var speechBubble = $CharacterBody2D/bubbleSpeech

var killPlayer = dataBase.kill
var dalamArea = false
var sedangBicara = false
var sudahTeksMenang = false
var sedangGantiScene
var jumlahInteraksi = 0
var nama = "Pak Faqih"
var namaPanggilan = "Pak Haji"


var teks1 = {
	1 : "Hey kek, ada apa ini, apa yang terjadi? kenapa banyak monster? dan dimana orang-orang??",
	2 : "Santai dikit napa.. udah kayak diintrogasi aja bahh..",
	3 : "Gimana gak santai liat kondisi seperti ini !!!",
	4 : "Lagian kemana aja sih kamu, masa baru tau?",
	5 : "Hehe..., Saya mau buat rekor gak tidur terlama kek",
	6 : "Tapi... Setelah itu saya ketiduran selama 1 bulan  *_*",
	7 : "Kacauu...",
	8 : "Hehehe....",
	9 : "Yaudah.. jadi ceritanya gini bre..",
	10 : "Minggu lalu, Bumi di serang monster-monster ganas yang menyerang warga. Lalu mang Elon membawa seluruh penduduk ke Mars untuk mengungsi",
	11 : "Kini.... atas persetujuan elit global, Bumi akan dimusnahkan. Tidak ada yang bisa hidup di Bumi lagi...",
	12 : "Umur bumi hanya tersisa 3 hari lagi sebelum bom nuklir diluncurkan",
	13 : "....",
	14 : "Tapi, apakah kamu ingin mengetahui 1 rahasia penting?",
	15 : "Rahasia apa? jangan membuatku penasaran...",
	16 : "Sebenarnya.... ",
	17 : "Ini semua hanyalah akal-akalan Elon agar ambisinya terwujud",
	18 : "Ha????",
	19 : "Ya... Bayangkan, Berapa banyak roket yang dibeli untuk memberangkatkan seluruh penduduk bumi...",
	20 : "Aku paham sekarang...",
	21 : "Tapi... Kenapa Kakek gak ikut ke Mars, Bukankah kondisi di sini berbahaya?",
	22 : "Hehehe... mereka mengusirku karena membawa durian *_*",
	23 : "Hadehh... lawak sekali kakek yang satu ini",
	24 : "....",
	25 : "Tapi... apakah sudah tidak ada cara lagi untuk menyelamatkan bumi?",
	26 : "Hmmm... Sepertinya ada...",
	27 : "Ha?? Serius kek?",
	28 : "Satu satunya cara adalah mengalahkan seluruh monster dan membongkar seluruh kelicikan Elon",
	29 : "Siapp... Aku akan berusaha semaksimal mungkin !!!",
}
var orang1 = {
	1 : dataBase.characterTerpilih,
	2 : nama,
	3 : dataBase.characterTerpilih,
	4 : nama,
	5 : dataBase.characterTerpilih,
	6 : dataBase.characterTerpilih,
	7 : nama,
	8 : dataBase.characterTerpilih,
	9 : nama,
	10 : nama,
	11 : nama,
	12 : nama,
	13 : dataBase.characterTerpilih,
	14 : nama,
	15 : dataBase.characterTerpilih,
	16 : nama,
	17 : nama,
	18 : dataBase.characterTerpilih,
	19 : nama,
	20 : dataBase.characterTerpilih,
	21 : dataBase.characterTerpilih,
	22 : nama,
	23 : dataBase.characterTerpilih,
	24 : nama,
	25 : dataBase.characterTerpilih,
	26 : nama,
	27 : dataBase.characterTerpilih,
	28 : nama,
	29 : dataBase.characterTerpilih
}

var teks2 = {
	1 : "Oiya kek... Kita lupa kenalan nihh..",
	2 : "Perkenalkan, namaku " + str(dataBase.characterTerpilih) + ", nama kakek siapa?",
	3 : "namaku " + str(nama) + ", tapi panggil saja aku " + str(namaPanggilan),
	4 : "Nahh... Ginikan jadi akrab",
	5 : "Okelahh... aku mau lanjut farming dulu..."
}
var orang2 = {
	1 : dataBase.characterTerpilih,
	2 : dataBase.characterTerpilih,
	3 : nama,
	4 : dataBase.characterTerpilih,
	5 : dataBase.characterTerpilih,
}

var teks3 = {
	1 : ""
}

var orang3 = {
	1 : nama,
	2 : dataBase.characterTerpilih,
	3 : nama,
	4 : dataBase.characterTerpilih,
	5 : nama,
	6 : dataBase.characterTerpilih,
	7 : nama,
	8 : dataBase.characterTerpilih
}

var teks4 = {
	1 : ""
}
var orang4 = {
	1 : nama,
	2 : dataBase.characterTerpilih,
	3 : nama,
	4 : dataBase.characterTerpilih,
	5 : nama,
	6 : dataBase.characterTerpilih,
	7 : nama,
	8 : dataBase.characterTerpilih
}

var teksMenang = {
	1 : "wahh.... gak nyangka kamu bisa membasmi semua monster itu sendirian",
	2 : "aku sangat takjub padamu wahai " + str(dataBase.characterTerpilih),
	3 : "Wahh... aku juga tidak menyangkanya. Akhirnya aku bisa mengembalikan kondisi bumi menjadi aman lagi",
}
var orangMenang = {
	1 : nama,
	2 : nama,
	3 : str(dataBase.characterTerpilih)
}

var dataTeksPercakapan = {
	1 : teks1,
	2 : teks2,
	3 : teks3,
	4 : teks4
}
var dataOrang = {
	1 : orang1,
	2 : orang2,
	3 : orang3,
	4 : orang4
}
var kecepatanBicara = 0.05	

func _ready() -> void:
	speechBubble.hide()

func _physics_process(_delta: float) -> void:
	
	killPlayer = dataBase.kill
	
	if (sudahTeksMenang && !sedangBicara) && !sedangGantiScene:
		sedangGantiScene = true
		get_tree().change_scene_to_file("res://scene/scene_tamat.tscn")
		return
	
	if (Input.is_action_just_pressed("i") && dalamArea) && !sedangBicara:
		sedangBicara = true
		updateTeksTerbaru()
		jumlahInteraksi += 1
		
		var dialoc = sceneDialog.instantiate()
		dialoc.kecepatan = kecepatanBicara
		
		if (dataBase.kill >= dataBase.totalMusuh):
			updateTeksTerbaru()
			dialoc.teks = teksMenang
			dialoc.orang = orangMenang
			add_child(dialoc)
			sudahTeksMenang = true
			return
		
		if (jumlahInteraksi > dataTeksPercakapan.size()):
			dialoc.teks = dataTeksPercakapan[dataTeksPercakapan.size()]
			dialoc.orang = dataOrang[dataTeksPercakapan.size()]
		else:
			dialoc.teks = dataTeksPercakapan[jumlahInteraksi]
			dialoc.orang = dataOrang[jumlahInteraksi]

		
		add_child(dialoc)


func _on_area_interaksi_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		dalamArea = true
		speechBubble.show()

func _on_area_interaksi_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		dalamArea = false
		speechBubble.hide()
	

func updateTeksTerbaru():
	teks3 = {
		1 : "ada apa lagi?",
		2 : "berapa banyak monster yang harus dimusnahkan?",
		3 : "kamu perlu membunuh " + str(dataBase.totalMusuh) + " musuh",
		4 : "Lalu, berapa banyak monster yang sudah saya bunuh?",
		5 : "Lahh... masak kamu lupa sihh",
		6 : "Hehehe...",
		7 : "kamu baru membunuh "  + str(killPlayer) + " musuh, jadi tersisa " + str(dataBase.totalMusuh - killPlayer) + " lagi",
		8 : "Wokee... Terimakasih inpo nyaa..."
	}
	teks4 = {
		1 : "Lupa lagi?",
		2 : "Hehehe... " + str(namaPanggilan) + " tau ajaa...",
		3 : "Dah ketebak Boss...",
		4 : "Hehehe...",
		5 : "kamu baru membunuh "  + str(killPlayer) + " musuh, jadi tersisa " + str(dataBase.totalMusuh - killPlayer) + " lagi",
		6 : "Wokee... Terimakasih kembali inpo nyaa...",
		7 : "Dicatet biar gak lupa ya...",
		8 : "Siapp " + str(namaPanggilan) + "..."
	}
	dataTeksPercakapan = {
		1 : teks1,
		2 : teks2,
		3 : teks3,
		4 : teks4
}
	dataOrang = {
		1 : orang1,
		2 : orang2,
		3 : orang3,
		4 : orang4
}
