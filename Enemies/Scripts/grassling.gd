extends CharacterBody2D

@onready var death_timer: Timer = $"Kill Timer"
@onready var health_bar: TextureProgressBar = $"Health Bar"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var timer: Timer = $Timer
@onready var weapon: CharacterBody2D = $"../Player/Weapon"
var move_speed = 25
var player_chase = false
var player = null
var health = 5
var freeze = false
var death_timer_start = false

func _physics_process(_delta):

#movement
	if player_chase == true and game_manager.freezeAll == false and freeze == false:
		velocity = position.direction_to(player.position) * move_speed
		move_and_slide()

#animations
		$AnimatedSprite2D.play("Run")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Idle")

#death
	if health < 1:
		freeze = true
		$AnimatedSprite2D.play("Death")
		if get_node("CollisionShape2D") != null:
			get_node("CollisionShape2D").queue_free()
		if death_timer_start == false:
			death_timer_start = true
			death_timer.start()

#health bar
	health_bar.value = health

func damage(x):
	health = (health - x)

func _on_follow_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

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

func _on_kill_timer_timeout() -> void:
	queue_free()
