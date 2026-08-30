extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var return_button_visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			return_button_visible = false
			get_tree().reload_current_scene()

func _process(_delta):
	if return_button_visible == true:
		animated_sprite_2d.play("enabled")
	elif return_button_visible == false:
		animated_sprite_2d.play("disabled")
