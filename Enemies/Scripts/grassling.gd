extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var timer: Timer = $Timer
@onready var weapon: CharacterBody2D = $"../Player/CharacterBody2D"
var move_speed = 25
var player_chase = false
var player = null
var health = 5

func _physics_process(_delta):
	if player_chase == true and game_manager.freezeAll == false:
		velocity = position.direction_to(player.position) * move_speed
		move_and_slide()
		$AnimatedSprite2D.play("Run")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Idle")

	if health < 1:
		queue_free()

func damage():
	health = (health - 5) 

func _on_follow_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

#func _on_follow_zone_body_exited(body: Node2D) -> void:
#	if body == player:
#		player = null
#		player_chase = false

func _on_combat_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_chase = false
		timer.start()
		attack()

func _on_combat_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = true
		timer.stop()

func _on_timer_timeout() -> void:
	attack()

func attack():
	game_manager.damage_player(2)
	animated_sprite.play("Attack")
