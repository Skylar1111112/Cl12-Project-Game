extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var reload_timer: Timer = $"Reload Timer"
@export var thistle_scene: PackedScene
var move_speed = 25
var player_chase = false
var player = null
var running = 1
var reloading = false
var health = 20
var can_attack = false

func _init():
	thistle_scene = preload("res://Enemies/Scenes/thistle.tscn")

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

	if can_attack == true:
		if reloading == false:
			reloading = true
			reload_timer.start()
			attack()

func damage():
	health = (health - 5)

func _on_follow_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	can_attack = false

func _on_combat_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_chase = false
		can_attack = true

func _on_combat_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = true
		can_attack = false

func attack():
	var thistle: CharacterBody2D = thistle_scene.instantiate()
	thistle.global_position = global_position
	thistle.velocity = (player.global_position - global_position) * thistle.movespeed
	get_tree().current_scene.add_child(thistle)
	thistle.player = player
	thistle.look_at(player.global_position)
	thistle.game_manager = game_manager

func _on_run_away_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_chase = true
		can_attack = false
		running = -1

func _on_run_away_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_chase = false
		can_attack = true
		running = 1

func _on_reload_timer_timeout() -> void:
	reloading = false
