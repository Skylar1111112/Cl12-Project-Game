extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var animated_sprite: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var player: CharacterBody2D = $".."
@onready var timer: Timer = $Timer
var weapon = "none"
var enemies: Array = []
var timer_is_going = false

func _process(_delta):
# animation stuff
	if weapon == "Sickle" and player.attacking == false:
		animation_player.play("Sickle")
		animated_sprite.play("Sickle")
	elif weapon == "Sickle" and player.attacking == true:
		animated_sprite.play("Sickle Attack")
		animation_player.play("Sickle")
	elif weapon == "Polesaw" and player.attacking == false:
		animation_player.play("Polesaw")
		animated_sprite.play("Polesaw")
	elif weapon == "Polesaw" and player.attacking == true:
		animation_player.play("Polesaw")
		animated_sprite.play("Polesaw Attack")
	elif weapon == "Shovel" and player.attacking == false:
		animation_player.play("Shovel")
		animated_sprite.play("Shovel")
	elif weapon == "Shovel" and player.attacking == true:
		animation_player.play("Shovel")
		animated_sprite.play("Shovel Attack")
	elif weapon == "none":
		animated_sprite.play("None")

	look_at(get_global_mouse_position())

	if player.attacking == true and enemies != null and timer_is_going == false:
			for enemy in enemies:
				enemy.damage()
			timer.start(0.3)
			timer_is_going = true

# Picking Weapon
	var one := Input.is_action_pressed("1")
	if one == true:
		weapon = "Sickle"
	var two := Input.is_action_pressed("2")
	if two == true:
		weapon = "Polesaw"
	var three := Input.is_action_pressed("3")
	if three == true:
		weapon = "Shovel"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("damage"):
				if body not in enemies:
					enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body in enemies:
			enemies.erase(body)


func _on_timer_timeout() -> void:
	timer_is_going = false
