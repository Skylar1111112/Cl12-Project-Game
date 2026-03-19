extends CharacterBody2D

@export var move_speed : float = 50
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	velocity = input_direction * move_speed
	move_and_slide()

	var Xdirection := Input.get_axis("left", "right")
	
	var Ydirection := Input.get_axis("up", "down")
	
	if Xdirection > 0:
		animated_sprite.flip_h = false
	elif Xdirection < 0:
		animated_sprite.flip_h = true

# Second way of doing movement animation
	#if Xdirection != 0 or Ydirection != 0:
	#		animated_sprite.play("Run")
	#else:
	#	animated_sprite.play("Idle")
	
	if Xdirection == 0 and Ydirection == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Run")
