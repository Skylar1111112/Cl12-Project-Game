extends CharacterBody2D
@onready var game_manager: Node = %GameManager


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			pass

func _process(_delta):
	if game_manager.mainMenu == true:
		pass #play enabled animation
	elif game_manager.mainMenu == false:
		pass #play disabled animation
