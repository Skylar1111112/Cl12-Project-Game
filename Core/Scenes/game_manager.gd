extends Node

var Health = 30
var trigger = true
@onready var health_label: Label = $"../Player/Health_Label"

func remove_point():
	Health -= 1
	if Health < 0:
		pass # trigger game over
	else:
		health_label.text = "Health = " + str(Health) +""


func _on_animated_sprite_2d_2_animation_finished() -> void:
	if trigger == true:
		health_label.text = "Health = " + str(Health) +""
		trigger = false
