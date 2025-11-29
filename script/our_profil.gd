extends Control

@onready var fotoBersama : TextureRect = $CanvasLayer/fotoBersama
@onready var fotoAfdhal : TextureRect = $CanvasLayer/TextureRect1
@onready var fotoAlif : TextureRect = $CanvasLayer/TextureRect2
@onready var fotoCassev : TextureRect = $CanvasLayer/TextureRect3
@onready var fotoRidwan : TextureRect =$CanvasLayer/TextureRect4
@onready var fotoFaqih : TextureRect = $CanvasLayer/TextureRect5
@onready var animasiPlayer : AnimationPlayer = $AnimationPlayer
@onready var soundSFX = preload("res://src/audio/langkah_rumput.wav")
@onready var fotoBersamaPath = preload("res://src/img/ourProfil/fotoBersama.jpg")
@onready var backgroundPath = preload("res://src/img/ui/backgroundGrid_kuning.jpg")
@onready var tombolDiKlik = preload("res://src/audio/tombolDitekan_SFX.WAV")


var status = {
	1 : false,
	2 : false,
	3 : false,
	4 : false,
	5 : false
}

var bisaAnimasi = false

func _ready() -> void:
	fotoAfdhal.modulate = Color(0.0, 0.0, 0.0, 0.0)
	fotoAlif.modulate = Color(0.0, 0.0, 0.0, 0.0)
	fotoCassev.modulate = Color(0.0, 0.0, 0.0, 0.0)
	fotoRidwan.modulate = Color(0.0, 0.0, 0.0, 0.0)
	fotoFaqih.modulate = Color(0.0, 0.0, 0.0, 0.0)


func _on_texture_rect_1_mouse_entered() -> void:
	animasiMasuk(1, fotoAfdhal, Vector2(2, 2), 0.4, backgroundPath, true)


func _on_texture_rect_2_mouse_entered() -> void:
	animasiMasuk(2, fotoAlif, Vector2(2, 2), 0.4, backgroundPath, true)


func _on_texture_rect_3_mouse_entered() -> void:
	animasiMasuk(3, fotoCassev, Vector2(2, 2), 0.4, backgroundPath, true)


func _on_texture_rect_4_mouse_entered() -> void:
	animasiMasuk(4, fotoRidwan, Vector2(2, 2), 0.4, backgroundPath, true)


func _on_texture_rect_5_mouse_entered() -> void:
	animasiMasuk(5, fotoFaqih, Vector2(2, 2), 0.4, backgroundPath, true)





func _on_texture_rect_1_mouse_exited() -> void:
	animasiMasuk(1, fotoAfdhal, Vector2(1, 1), 0.4, fotoBersamaPath, false)


func _on_texture_rect_2_mouse_exited() -> void:
	animasiMasuk(2, fotoAlif, Vector2(1, 1), 0.4, fotoBersamaPath, false)


func _on_texture_rect_3_mouse_exited() -> void:
	animasiMasuk(3, fotoCassev, Vector2(1, 1), 0.4, fotoBersamaPath, false)


func _on_texture_rect_4_mouse_exited() -> void:
	animasiMasuk(4, fotoRidwan, Vector2(1, 1), 0.4, fotoBersamaPath, false)


func _on_texture_rect_5_mouse_exited() -> void:
	animasiMasuk(5, fotoFaqih, Vector2(1, 1), 0.4, fotoBersamaPath, false)




func animasiMasuk(nomorNode, node, ukuran, durasi, background, is_mauMasuk):
	
	if is_mauMasuk:
		status[nomorNode] = true
		bisaAnimasi = false
		await get_tree().create_timer(0.2).timeout
		bisaAnimasi = true
		if bisaAnimasi && status[nomorNode] == true:
			putarSFX(soundSFX)
			fotoBersama.texture = background
			node.modulate = Color(1, 1, 1, 1)
			var animasi = create_tween()
			animasi.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			animasi.tween_property(node, "scale", ukuran, durasi)
			bisaAnimasi = false
	else:
		status[nomorNode] = false
		putarSFX(soundSFX)
		fotoBersama.texture = background
		var animasiKeluar = create_tween()
		animasiKeluar.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		animasiKeluar.tween_property(node, "scale", ukuran, durasi * 0.2)
		node.modulate = Color(0.0, 0.0, 0.0, 0.0)
		
	
	
	#if !is_mauMasuk:
		#await get_tree().create_timer(durasi).timeout
		#
	#

func putarSFX(sound):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(audioPlayer.queue_free)


func _on_close_pressed() -> void:
	putarSFX(tombolDiKlik)
	animasiPlayer.play("close")
	await animasiPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn")
