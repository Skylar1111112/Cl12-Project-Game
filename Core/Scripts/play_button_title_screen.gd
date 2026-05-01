extends AnimatedSprite2D
@onready var game_manager: Node = %GameManager
var 

func buttonVisable():
	if game_manager.mainMenu == true:
		play("Enabled")
	else:
		play("Disabled")

func _process(_delta):
	if
