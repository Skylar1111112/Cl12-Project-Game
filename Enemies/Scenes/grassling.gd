extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@export var move_speed : float = 60
var player_chase = false
@onready var player = null
@onready var timer: Timer = $Timer

func _ready() -> void:
	$"Follow Zone/CollisionShape2D".shape.radius = get_meta("FDistance")
	$"Combat Zone/CollisionShape2D".shape.radius = get_meta("CDistance")
	
func _physics_process(delta: float) -> void:
	if game_manager.gameRunning:	
		if player_chase:
			$AnimatedSprite2D.play("Run")
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			velocity = Vector2(
				player.position.x - position.x,
				player.position.y - position.y
			) * (1/move_speed)
			
			move_and_slide()
		else:
			$AnimatedSprite2D.play("Idle")
	

func _on_follow_zone_body_entered(body: Node2D) -> void:
	print("FEnt")
	player = body
	player_chase = true

func _on_follow_zone_body_exited(body: Node2D) -> void:
	print("FEx")
	player = null
	player_chase = false
	

func _on_combat_zone_body_entered(body: Node2D) -> void:
	print("CEnt")
	if body == player:
		player_chase = false
		timer.start()

func _on_combat_zone_body_exited(body: Node2D) -> void:
	print("CEx")
	if body == player:
		player_chase = true
		timer.stop()

func _on_timer_timeout() -> void:
	print("TTime")
	animated_sprite.play("Attack")
	player_chase = true
	game_manager.remove_point()
	
