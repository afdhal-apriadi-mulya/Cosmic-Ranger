extends Control
@onready var bar_darah : ProgressBar = $healthBar
@onready var bar_damage : ProgressBar = $healthBar/damageBar
@onready var timer : Timer = $Timer

var maxDarah
var nyawa
var darah_berkurang = false
var typeVisibility = true


func _ready() -> void:
	self.visible = false
	await get_tree().create_timer(0.05).timeout
	if typeVisibility:
		self.visible = false
	else:
		self.visible = true
	bar_darah.max_value = maxDarah
	bar_damage.max_value = maxDarah
	bar_darah.value = maxDarah
	bar_damage.value = bar_darah.value
	
	

func _physics_process(_delta: float) -> void:
	bar_darah.value = nyawa 
	updateDarah()
	update_barDamage()
	
	if (bar_damage.value < bar_darah.value):
		bar_damage.value = bar_darah.value
		darah_berkurang = false
	
	#if (nyawa <= 0):
		#bar_darah.value = 0
	

func updateDarah():
	if (bar_darah.value < bar_damage.value):
		await get_tree().create_timer(0.5).timeout
		darah_berkurang = true
	else:
		darah_berkurang = false


func update_barDamage():
	if (!darah_berkurang):
		return
	bar_damage.value -= 1

func visibility():
	self.visible = true
	timer.stop()
	timer.start(5)


func _on_timer_timeout() -> void:
	self.visible = false
	pass
