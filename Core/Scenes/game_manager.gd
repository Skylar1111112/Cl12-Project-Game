extends Node

var Health = 30
var trigger = true
@export var gameRunning : bool = false
@onready var health_label: Label = $"../Player/HUD/Health_Label"
signal startGame

func remove_point():
	Health -= 1
	if Health < 0:
		pass # trigger game over
	else:
		health_label.text = "Health = " + str(Health) +""


func _on_animated_sprite_2d_2_animation_finished() -> void:
	if gameRunning == false:
		startGame.emit()
		gameRunning = true
		health_label.text = "Health = " + str(Health) +""
