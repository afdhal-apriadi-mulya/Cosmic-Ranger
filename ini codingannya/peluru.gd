extends RigidBody2D

#  <-- PENAMAAN VARIABEL -->
var kecepatan : float = 55000.0
var globalPos : Vector2
var posisiMouse : Vector2
var posisiPistol
var pos_ujung
var damage = 30.00
var arah

func _ready() -> void:
	global_position = globalPos
	arah = (pos_ujung - posisiPistol).normalized()
	look_at(get_global_mouse_position())
	pass

func _physics_process(delta: float) -> void:
	linear_velocity = arah * kecepatan * delta
	
	hapusObject()

func shoot():
	pass
	
	
func hapusObject():
	var batasObject = dataBase.luasMap #[atas, kanan, bawah, kiri]
	if (float(global_position.x) < -batasObject[3] || float(global_position.x) > batasObject[1] || float(global_position.y) < -batasObject[0]) || float(global_position.y) > batasObject[2]:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyParent
	if (body.is_in_group("musuh")):
		bodyParent = body.get_parent().get_parent()
		bodyParent.kenaHit("pistol", damage, 0, global_position)
		queue_free()
	if (body.is_in_group("objek")):
		queue_free()
	pass # Replace with function body.
