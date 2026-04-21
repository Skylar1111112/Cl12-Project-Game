extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@export var move_speed : float = 60
var player_chase = false
var player = null
@onready var timer: Timer = $Timer
 
func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/move_speed
		$AnimatedSprite2D.play("Run")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle")
	move_and_slide()

func _on_follow_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_follow_zone_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	

func _on_combat_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_chase = false
		timer.start()

func _on_combat_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = true
		timer.stop()

func _on_timer_timeout() -> void:
	animated_sprite.play("Attack")
	player_chase = true
	game_manager.remove_point()
	
