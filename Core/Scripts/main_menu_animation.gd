extends AnimatedSprite2D
@onready var game_manager: Node = %GameManager

func _process(_delta):
	if game_manager.mainMenu == true:
		play("MainMenu")
