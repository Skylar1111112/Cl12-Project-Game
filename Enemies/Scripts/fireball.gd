extends CharacterBody2D
@onready var game_manager: Node = %GameManager
@onready var player: CharacterBody2D = %Player
var movespeed = 1

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _physics_process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		move_and_slide()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body == player:
		game_manager.damage_player(10)
		queue_free()
