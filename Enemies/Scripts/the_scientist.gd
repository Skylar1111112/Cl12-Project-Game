extends CharacterBody2D

@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var weapon: CharacterBody2D = $"../Player/Weapon"
@onready var attack_timer: Timer = $"Attack Timer"
@onready var death_timer: Timer = $"Death Timer"
@onready var specific_timer: Timer = $"Specific Timer"
@onready var whirlwind_attack_timer: Timer = $"Whirlwind Attack Timer"
@export var fire_ball_scene: PackedScene
@export var lightning_scene: PackedScene
var attack_type = 0
var move_speed = 25
var player_chase = false
var player = null
var running = 1
var reloading = false
var health = 200
var freeze = false
var death_timer_start = false
var timer_over = true
var physical_attack = false
var whirlwind_attack_timer_going = false
var whirlwind_attack_stage = 0

func _init():
	fire_ball_scene = preload("res://Enemies/Scenes/fire_ball.tscn")
	lightning_scene = preload("res://Enemies/Scenes/lightning.tscn")

func _physics_process(_delta):

#movement
	if player_chase == true and game_manager.freezeAll == false and freeze == false:
		velocity = position.direction_to(player.position) * move_speed * running
		move_and_slide()

#death
	if health < 1:
		freeze = true
		$AnimatedSprite2D.play("Death")
		if get_node("CollisionShape2D") != null:
			get_node("CollisionShape2D").queue_free()
		if death_timer_start == false:
			death_timer_start = true
			death_timer.start()

#reload
	if game_manager.freezeAll == false and player != null:
		if reloading == false:
			attack_type = randi_range(1,3)
			attack_timer.start(5)
			reloading = true
		attack()

#health bar
	health_bar.value = health

func damage(x):
	health = (health - x)

func _on_follow_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func attack():
	if attack_type == 1 and timer_over == true:
		freeze = true
		animated_sprite.play("Fire Attack")
		var fire_ball: CharacterBody2D = fire_ball_scene.instantiate()
		fire_ball.global_position = global_position
		fire_ball.velocity = (player.global_position - global_position) * fire_ball.movespeed
		get_tree().current_scene.add_child(fire_ball)
		fire_ball.player = player
		fire_ball.look_at(player.global_position)
		fire_ball.game_manager = game_manager
		timer_over = false
		specific_timer.start(0.5)
	elif attack_type == 2 and timer_over == true:
		freeze = true
		animated_sprite.play("Lightning Attack")
		var ligntning: CharacterBody2D = lightning_scene.instantiate()
		ligntning.global_position = player.position
		ligntning.velocity = Vector2(0,0)
		get_tree().current_scene.add_child(ligntning)
		ligntning.player = player
		ligntning.game_manager = game_manager
		timer_over = false
		specific_timer.start(2)
	elif attack_type == 3 and timer_over == true:
		freeze = false
		if timer_over == true and whirlwind_attack_stage == 0:
			animated_sprite.play("Whirlwind Start")
			specific_timer.start(0.6)
			timer_over = false
			whirlwind_attack_stage = 1
		elif timer_over == true and whirlwind_attack_stage == 1:
			animated_sprite.play("Whirlwind Attack")
			physical_attack = true
			specific_timer.start(3)
			timer_over = false
			whirlwind_attack_stage = 2
		elif timer_over == true and whirlwind_attack_stage == 2:
			physical_attack = false
			animated_sprite.play("Whirlwind End")
			whirlwind_attack_stage = 0

func _on_reload_timer_timeout() -> void:
	reloading = false

func _on_death_timer_timeout() -> void:
	#queue_free()
	pass

func _on_specific_timer_timeout() -> void:
	timer_over = true


func _on_whirlwind_attack_area_body_entered(body: Node2D) -> void:
	if body == player and physical_attack == true and whirlwind_attack_timer_going == false:
		damage(3)
		whirlwind_attack_timer.start(0.2)
		whirlwind_attack_timer_going = true


func _on_whirlwind_attack_timer_timeout() -> void:
	whirlwind_attack_timer_going = false
