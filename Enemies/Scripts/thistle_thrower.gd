extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var timer: Timer = $Timer
@onready var reload_timer: Timer = $"Reload Timer"
var move_speed = 25
var player_chase = false
var player = null
var running = 1
var reloading = false
var health = 10

func _physics_process(_delta):
	if player_chase == true and game_manager.freezeAll == false:
		velocity = position.direction_to(player.position) * move_speed * running
		move_and_slide()
		if reloading == false:
			$AnimatedSprite2D.play("Run")
		elif reloading == true:
			$AnimatedSprite2D.play("Run+Attack")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif reloading == false:
		$AnimatedSprite2D.play("Idle")
	elif reloading == true:
		$AnimatedSprite2D.play("Attack")

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
		if reloading == false:
			reloading = true
			reload_timer.start()
			attack()

func _on_combat_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = true
		timer.stop()

func _on_timer_timeout() -> void:
	if reloading == false:
		reloading = true
		reload_timer.start()
		attack()

func attack():
	pass #spawn thistle

func _on_run_away_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_chase = true
		timer.stop()
		running = -1


func _on_run_away_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = false
		running = 1


func _on_reload_timer_timeout() -> void:
	reloading = false
