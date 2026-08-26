extends CharacterBody2D
var game_manager = null
var player = null
@onready var timer: Timer = $"Timer"
var movespeed = 1
var can_attack = false
var target = null

func _physics_process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		move_and_slide()
	if target != null and can_attack == true:
		game_manager.damage_player(10)
		queue_free()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body == player:
		target = body

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body == player:
		target = null

func _on_timer_timeout() -> void:
	if can_attack == false:
		timer.start(1)
		can_attack = true
	elif can_attack == true:
		queue_free()
