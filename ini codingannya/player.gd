extends Node2D

@onready var player : CharacterBody2D = $CharacterBody
@onready var animasi : AnimatedSprite2D = $CharacterBody/AnimatedSprite2D
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var darah_bar = $CharacterBody/Darah
@onready var camera = $CharacterBody/Camera2D
@onready var labelNamaPlayer : Label = $CharacterBody/namaPlayer
@onready var pistolPath = load("res://scene/riffle.tscn")
@onready var doublePistolPath = load("res://scene/doublePistol.tscn")
@onready var shotgunPath = load("res://scene/shotgun.tscn")
@onready var worldPath = load("res://scene/world.tscn")
@onready var sound_Lari = preload("res://src/audio/langkah_kayu.wav")
@onready var sound_gantiSenjataPath = preload("res://src/audio/gantiSenjata_SFX.wav")
@onready var UI_KalahPath = load("res://scene/ui_kalah.tscn")
@onready var tebasanPedangSFX = preload("res://src/audio/tebasanPedangSFX.wav")

var arahTerakhir = "bawah"
var koleksiSenjata = ["pedang", "riffle", "doublePistol", "shotgun"]
var senjataSaatIni = "pedang"
var index_jenisSenjata = 0
var nyawa
var is_attack = false
var change_scene = false
var can_soundJalan = true
var damagePedang = 50.00
var adaPedang
var scalaSenjata
var posisiSenjata
var highscoreLama

func _ready() -> void:
	is_attack = false
	darah_bar.typeVisibility = false
	nyawa = dataBase.max_nyawa_P1
	dataBase.nyawa_P1 = dataBase.max_nyawa_P1
	dataBase.player_dead = false
	darah_bar.maxDarah = dataBase.max_nyawa_P1
	$CharacterBody/player_attack/CollisionShape2D.disabled = true
	dataBase.luasMap = [camera.limit_top, camera.limit_right, camera.limit_bottom, camera.limit_left]
	dataBase.updateDataStore.connect(updateDataStore)
	dataBase.ulangPermainan.connect(ulangPermainan)
	penyesuaianCharacter()
	highscoreLama = dataBase.hightScore
	labelNamaPlayer.text = dataBase.characterTerpilih
	
	#$CharacterBody/Area2D.global_position = Vector2(player.global_position.x, player.global_position.y + 8)

#kecepatan
var kecepatan = dataBase.kecepatanPlayer
var kecepatanLibasan = kecepatan * 2.3
var kecepatanAwal = kecepatan

func _physics_process(_delta: float) -> void:
	if dataBase.player_dead == true:
		return
	
	update_gerakan()
	
	update_jenisSenjataSaatIni()
	
	updateSound()
	
	if (Input.is_action_just_pressed("attack") && senjataSaatIni == "pedang") && adaPedang:
		adaPedang = false
		updateAnimasiPedang()
	elif (is_attack == false):
		updateAnimasiJalan()
	
	#kalau nyerang pakai pedang = kecepatannya bertambah kencang selama proses penyerangan
	if (is_attack == true):
		kecepatan = kecepatanLibasan
	else:
		kecepatan = kecepatanAwal
	
	#update data yang akan dipakai scene lain
	update_dataBase()
	darah_bar.nyawa = nyawa
	
	if (dataBase.nyawa_P1 > dataBase.max_nyawa_P1):
		dataBase.nyawa_P1 = dataBase.max_nyawa_P1
	
	#if ($player_attack/CollisionShape2D.disabled):
		#print("disable")
	#elif ($player_attack/CollisionShape2D.disabled == false):
		#print("aktif")
	



func update_gerakan():
	if (Input.is_action_pressed("kanan")):
		player.velocity.x = kecepatan
	elif (Input.is_action_pressed("kiri")):
		player.velocity.x = -kecepatan
	if (Input.is_action_pressed("atas")):
		player.velocity.y = -kecepatan
	elif (Input.is_action_pressed("bawah")):
		player.velocity.y = kecepatan
	
	var perlambatan : float = 0.2
	player.velocity.x = lerp(float(player.velocity.x), 0.0, perlambatan)
	player.velocity.y = lerp(float(player.velocity.y), 0.0, perlambatan)
	
	player.move_and_slide()
	
	
func updateAnimasiJalan():
	if (Input.is_action_pressed("kanan")):
		animasi.play("runRight")
		animasi.flip_h = false
		arahTerakhir = "kanan"
	elif (Input.is_action_pressed("kiri")):
		animasi.play("runRight")
		animasi.flip_h = true
		arahTerakhir = "kiri"
	elif (Input.is_action_pressed("atas")):
		if (Input.is_action_pressed("attack") && (senjataSaatIni == "riffle" || senjataSaatIni == "doublePistol" || senjataSaatIni == "shotgun")):
			animasi.play("runFront")
			arahTerakhir = "atas"
		else:
			animasi.play("runBack")
			arahTerakhir = "atas"
		
	elif (Input.is_action_pressed("bawah")):
		animasi.play("runFront")
		arahTerakhir = "bawah"
	else:
		if (arahTerakhir == "kanan"):
			animasi.play("idleRight")
		elif (arahTerakhir == "kiri"):
			animasi.play("idleRight")
		elif (arahTerakhir == "atas"):
			if (Input.is_action_pressed("attack") && (senjataSaatIni == "riffle" || senjataSaatIni == "doublePistol" || senjataSaatIni == "shotgun")):
				animasi.play("idleFront")
				arahTerakhir = "bawah"
			else:
				animasi.play("idleBack")
				arahTerakhir = "atas"
		else:
			animasi.play("idleFront")


func updateAnimasiPedang():
	putarSFX(tebasanPedangSFX)
	if (arahTerakhir == "kiri"):
		animationPlayer.play("attackLeft")
	elif (arahTerakhir == "kanan"):
		animationPlayer.play("attackRight") 
	elif (arahTerakhir == "atas"):
		animationPlayer.play("atackBack")
	else:
		animationPlayer.play("attackFront")
	await animationPlayer.animation_finished
	adaPedang = true



func update_jenisSenjataSaatIni():
	if (Input.is_action_just_pressed("shift")):
		putarSFX(sound_gantiSenjataPath)
		if (index_jenisSenjata == koleksiSenjata.size() - 1):
			index_jenisSenjata = -1
		index_jenisSenjata += 1
		senjataSaatIni = koleksiSenjata[index_jenisSenjata]
		print (senjataSaatIni)
		print (index_jenisSenjata)
		print (koleksiSenjata.size())
		
		if (senjataSaatIni == "riffle"):
			var pistol = pistolPath.instantiate()
			#pistol.global_position = player.global_position.x + 6
			pistol.position = posisiSenjata[1]
			pistol.scale = scalaSenjata[1]
			player.add_child(pistol)
		elif (senjataSaatIni == "doublePistol"):
			var doublePistol = doublePistolPath.instantiate()
			doublePistol.position = posisiSenjata[2]
			doublePistol.scale = scalaSenjata[2]
			player.add_child(doublePistol)
			
			var doublePistol2 = doublePistolPath.instantiate()
			doublePistol2.position = posisiSenjata[3]
			doublePistol2.scale = scalaSenjata[2]
			player.add_child(doublePistol2)
		elif (senjataSaatIni == "shotgun"):
			var shotgun = shotgunPath.instantiate()
			#pistol.global_position = player.global_position.x + 6
			shotgun.position = posisiSenjata[4]
			shotgun.scale = scalaSenjata[3]
			player.add_child(shotgun)





func update_dataBase():
	dataBase.Global_posisiPlayer = player.global_position
	dataBase.senjataSaatIni = senjataSaatIni


func kebal(jumlah):
	dataBase.player_kebal = true
	$CharacterBody/player_hitBox/CollisionShape2D.disabled = true
	for i in range(jumlah):
		animasi.modulate = Color(18.892, 18.892, 18.892, 1.0)
		await get_tree().create_timer(0.1).timeout
		animasi.modulate = Color(1,1, 1, 1)
		await get_tree().create_timer(0.1).timeout
		print ("for ke: " + str(i))
	$CharacterBody/player_hitBox/CollisionShape2D.disabled = false
	print ("for selesai" )
	dataBase.player_kebal = false

func _on_player_attack_pedang_body_entered(body: Node2D) -> void:
	if (body.is_in_group("musuh")):
		body.owner.kenaHit("pedang", damagePedang, 3000, player.global_position)
	pass # Replace with function body.

func kenaHit(_type, damageDiterima, posisiSenjata, KekuatanPantulan):
	if change_scene:
		return
	if dataBase.player_kebal:
		return
	
	nyawa -= damageDiterima
	dataBase.nyawa_P1 = nyawa
	print (nyawa)
	if (nyawa <= 0 && dataBase.player_dead == false):
		dataBase.player_dead = true
		darah_bar.nyawa = 0
		$CharacterBody/player_hitBox/CollisionShape2D.disabled = true
		animasi.play("dead")
		await animasi.animation_finished
		dataBase.saveData()
		var UI_kalah = UI_KalahPath.instantiate()
		UI_kalah.highscoreLama = highscoreLama
		add_child(UI_kalah)
	else:
		kebal(5)
		var arah = posisiSenjata - player.global_position
		player.velocity = arah.normalized() * KekuatanPantulan


func updateSound():
	if (Input.is_action_pressed("atas") || Input.is_action_pressed("bawah") || Input.is_action_pressed("kiri") || Input.is_action_pressed("kanan")) && can_soundJalan:
		can_soundJalan = false
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.stream = sound_Lari
		add_child(audioPlayer)
		audioPlayer.play()
		await get_tree().create_timer(0.24).timeout
		audioPlayer.queue_free()
		can_soundJalan = true
	


func updateDataStore(jenisData : String, nilai):
	if (jenisData == "nyawa"):
		nyawa = dataBase.nyawa_P1
	elif (jenisData == "kecepatan"):
		kecepatan = dataBase.kecepatanPlayer
	elif (jenisData == "maxDarah"):
		nyawa = dataBase.nyawa_P1
		darah_bar.bar_darah.max_value = dataBase.max_nyawa_P1
		darah_bar.bar_damage.max_value = dataBase.max_nyawa_P1

func ulangPermainan():
	$CharacterBody/player_hitBox/CollisionShape2D.disabled = false
	dataBase.player_dead = false
	dataBase.nyawa_P1 = dataBase.max_nyawa_P1
	nyawa = dataBase.max_nyawa_P1
	highscoreLama = dataBase.hightScore


func putarSFX(soundPath):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = soundPath
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)


func penyesuaianCharacter():
	if (self.name == "player1"):
		adaPedang = true
		scalaSenjata = [null, Vector2(0.12, 0.12), Vector2(1, 1), Vector2(0.045, 0.045)]
		posisiSenjata = [null, Vector2(6.0, -12.0), Vector2(14.0, -18.0), Vector2(-14.0, -18.0), Vector2(6.0, -16.0)]
	elif (self.name == "player2"):
		adaPedang = true
		scalaSenjata = [null, Vector2(0.07, 0.07), Vector2(0.625, 0.625), Vector2(0.023, 0.023)]
		posisiSenjata = [null, Vector2(3.0, -11.0), Vector2(11.0, -12.0), Vector2(-10.0, -12.0), Vector2(3.5, -13.7)]
