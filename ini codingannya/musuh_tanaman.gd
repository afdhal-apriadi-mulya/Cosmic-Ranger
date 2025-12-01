extends Node2D

# <--PENAMAAN VARIABEL -->
@onready var tanaman : CharacterBody2D = $CharacterBody2D
@onready var animasi : AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var hitBox : CollisionShape2D = $CharacterBody2D/enemy_hitBox/CollisionShape2D
@onready var animasiPlayer : AnimationPlayer = $CharacterBody2D/AnimationPlayer
@onready var bar_darah : Control = $CharacterBody2D/Darah
@onready var koinPath = load("res://scene/koin.tscn")


var kecepatan : float = 47.0
var nyawa = dataBase.darahTanaman
var dead = false
var kejar = true
var playerMasuk = false
var jenisAnim = 1
var damage = dataBase.damageTanaman
var arah
var arahAnim
var tujuan
var offset

func _ready() -> void:
	bar_darah.maxDarah = nyawa
	bar_darah.nyawa = nyawa
	bar_darah.typeVisibility = true
	$CharacterBody2D/enemy_attack/CollisionShape2D.disabled = true
	


func _physics_process(_delta: float) -> void:
	update_offset()
	if(kejar == true && dead == false):
		kejarPlayer()
	
	bar_darah.nyawa = nyawa


func update_offset():
	if(dataBase.Global_posisiPlayer == null):
		return
	
	if (float(dataBase.Global_posisiPlayer.x) < float(tanaman.global_position.x)):
		offset = 10
		animasi.flip_h = true
		arahAnim = "kiri"
	else:
		offset = -10
		animasi.flip_h = false
		arahAnim = "kanan"
		#global_position = tengkorak.global_position



func kejarPlayer():
	if (dataBase.Global_posisiPlayer == null):
		print("null")
		return
	arah = Vector2(float(dataBase.Global_posisiPlayer.x + offset), dataBase.Global_posisiPlayer.y) - tanaman.global_position
	tanaman.velocity = arah.normalized() * kecepatan
	
	var perlambatan : float = 0.001
	tanaman.velocity.x = lerp(float(tanaman.velocity.x), 0.0, perlambatan)
	tanaman.velocity.y = lerp(float(tanaman.velocity.y), 0.0, perlambatan)
	
	tanaman.move_and_slide()

	#animasi
	animasi.play("run")


func kenaHit(_type, damageDiterima, kekuatanPental,  posisiSenjata):
	bar_darah.visibility()
	$CharacterBody2D/enemy_hitBox/CollisionShape2D.disabled = true
	kejar = false
	nyawa -= damageDiterima
	if(nyawa <= 0 && !dead):
		dead = true
		animasi.play("dead")
		dataBase.score += 2
		dataBase.kill += 1
		var koin = koinPath.instantiate()
		get_parent().add_child(koin)
		koin.global_position = tanaman.global_position
		await animasi.animation_finished
		queue_free()
	else:
		animasi.play("sakit")
		
		# <-- TENGKORAK TERPENTAL SAAT KENA PEDANG KERAMAT "_" -->
		arah = tanaman.global_position - posisiSenjata
		tanaman.velocity = arah.normalized() * kekuatanPental
		tanaman.move_and_slide()
		kebal(5)
		
		await animasi.animation_finished
		kejar = true
		
func kebal(jumlah):
	$CharacterBody2D/enemy_hitBox/CollisionShape2D.disabled = true
	for i in range(jumlah):
		animasi.modulate = Color(18.892, 18.892, 18.892)
		await get_tree().create_timer(0.1).timeout
		animasi.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
	$CharacterBody2D/enemy_hitBox/CollisionShape2D.disabled = false




func _on_animated_sprite_2d_animation_finished(anim_name) -> void:
	if (anim_name == "sakit"):
		print ("sakit")
		kejar = true
	if (anim_name == "dead"):
		print ("dead")
		queue_free()
	pass # Replace with function body.


func _on_area_serang_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_trigerHit")):
		playerMasuk = true
		kejar = false
		
		while playerMasuk:
			
			animasiPlayer.play("attack" + str(jenisAnim) + "_" + arahAnim)
			jenisAnim += 1
			
			if jenisAnim > 3:
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
			body.owner.kenaHit("pisau", damage, $CharacterBody2D/enemy_attack.global_position, 1800)
	pass # Replace with function body.
