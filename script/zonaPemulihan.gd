extends Node2D

var heal = false
var Player

func _physics_process(_delta: float) -> void:
	tambahDarah()

func tambahDarah():
	if heal:
		if (dataBase.nyawa_P1 >= dataBase.max_nyawa_P1):
			return
		await get_tree().create_timer(0.1).timeout
		dataBase.nyawa_P1 += 1
		Player.nyawa = dataBase.nyawa_P1
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		Player = body.get_parent()
		heal = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		Player = body.get_parent()
		heal = false
