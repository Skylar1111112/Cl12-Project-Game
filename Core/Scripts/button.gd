extends CharacterBody2D
@onready var game_manager: Node = %GameManager
@onready var menuButton: AnimatedSprite2D = $AnimatedSprite2D

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and game_manager.paused == true:
		if event.button_index == MOUSE_BUTTON_LEFT:
			game_manager.main_menu_change()

func _process(_delta):
	if game_manager.paused == true:
		menuButton.play("Enabled")
	elif game_manager.paused == false:
		menuButton.play("Disabled")
