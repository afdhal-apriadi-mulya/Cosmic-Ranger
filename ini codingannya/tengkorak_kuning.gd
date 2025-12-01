extends Node2D

# <--PENAMAAN VARIABEL -->
@onready var tengkorak : CharacterBody2D = $CharacterBody
@onready var animasi : AnimatedSprite2D = $CharacterBody/AnimatedSprite2D
@onready var hitBox : CollisionShape2D = $CharacterBody/enemy_hitBox/CollisionShape2D
@onready var animasiPlayer : AnimationPlayer = $CharacterBody/AnimationPlayer
@onready var darah_bar : Control = $CharacterBody/Darah_Musuh


var kecepatan : float = 40.0
var nyawa = 100
var dead = false
var kejar = true
var playerMasuk = false
var jenisAnim = 1
var damage = 15.00
var arah
var arahAnim
var tujuan
var offset

func _ready() -> void:
	darah_bar.nyawa = nyawa
	darah_bar.maxDarah = nyawa
	darah_bar.typeVisibility = true


func _physics_process(_delta: float) -> void:
	update_offset()
	if(kejar == true && dead == false):
		kejarPlayer()
	darah_bar.nyawa = nyawa


func update_offset():
	if (float(dataBase.Global_posisiPlayer.x) < float(tengkorak.global_position.x)):
		offset = 10
		animasi.flip_h = true
		arahAnim = "kiri"
	else:
		offset = -10
		animasi.flip_h = false
		arahAnim = "kanan"
		#global_position = tengkorak.global_position



func kejarPlayer():
	arah = Vector2(float(dataBase.Global_posisiPlayer.x + offset), dataBase.Global_posisiPlayer.y) - tengkorak.global_position
	tengkorak.velocity = arah.normalized() * kecepatan
	
	var perlambatan : float = 0.001
	tengkorak.velocity.x = lerp(float(tengkorak.velocity.x), 0.0, perlambatan)
	tengkorak.velocity.y = lerp(float(tengkorak.velocity.y), 0.0, perlambatan)
	
	tengkorak.move_and_slide()

	#animasi
	animasi.play("run")


func kenaHit(_type, damageDiterima, kekuatanPental,  posisiSenjata):
	darah_bar.visibility()
	$CharacterBody/enemy_hitBox/CollisionShape2D.disabled = true
	kejar = false
	nyawa -= damageDiterima
	if(nyawa <= 0 && !dead):
		dead = true
		animasi.play("dead")
		dataBase.score += 2
		await animasi.animation_finished
		queue_free()
	else:
		animasi.play("sakit")
		
		# <-- TENGKORAK TERPENTAL SAAT KENA PEDANG -->
		arah = tengkorak.global_position - posisiSenjata
		tengkorak.velocity = arah.normalized() * kekuatanPental
		tengkorak.move_and_slide()
		kebal(5)
		
		await animasi.animation_finished
		kejar = true
		
func kebal(jumlah):
	$CharacterBody/enemy_hitBox/CollisionShape2D.disabled = true
	for i in range(jumlah):
		animasi.modulate = Color(18.892, 18.892, 18.892)
		await get_tree().create_timer(0.1).timeout
		animasi.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
	$CharacterBody/enemy_hitBox/CollisionShape2D.disabled = false







func _on_area_serang_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_trigerHit")):
		playerMasuk = true
		kejar = false
		
		while playerMasuk:
			
			if (arahAnim == "kanan"):
				animasiPlayer.play("attack" + str(jenisAnim))
				jenisAnim += 1
				print ("anim kanan")
			elif (arahAnim == "kiri"):
				animasiPlayer.play("attack" + str(jenisAnim) + "_kiri")
				jenisAnim += 1
				print ("anim kiri")
			if jenisAnim > 2:
				jenisAnim = 1
				
			await animasiPlayer.animation_finished
				
	
	pass # Replace with function body.


func _on_area_serang_area_exited(area: Area2D) -> void:
	if (area.is_in_group("player_trigerHit")):
		playerMasuk = false
		kejar = true
	pass # Replace with function body.


func _on_enemy_attack_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player_hitBox")):
		if dataBase.player_dead:
			return
		else:
			body.owner.kenaHit("pisau", damage, $CharacterBody/enemy_attack.global_position, 1200)
	pass # Replace with function body.
