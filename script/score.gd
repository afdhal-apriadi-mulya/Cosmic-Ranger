extends Label

var hightScore

func _ready() -> void:
	dataBase.ulangPermainan.connect(ulangPermainan)
	hightScore = dataBase.hightScore
	if (self.name == "hightScore"):
		text = str(hightScore)

func _physics_process(_delta: float) -> void:
	#text = "SCORE: " + str(dataBase.score) + "\nHIGHTSCORE: " + str(hightScore)
	
	if (self.name == "score"):
		text = str(dataBase.score)
	
	if (dataBase.score > dataBase.hightScore):
		dataBase.hightScore = dataBase.score


func ulangPermainan():
	hightScore = dataBase.hightScore
	if (self.name == "hightScore"):
		text = str(hightScore)
