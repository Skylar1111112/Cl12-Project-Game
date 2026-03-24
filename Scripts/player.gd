extends CharacterBody2D

@export var move_speed : float = 40
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

#attack code
	var attacking := Input.is_action_pressed("attack")

	var moving : bool
	if Xdirection != 0 or Ydirection != 0:
		moving = true
	else:
		moving = false

#movement animation
	if moving == true and attacking == false:
		animated_sprite.play("Run")
	elif moving == false and attacking == true:
		animated_sprite.play("Attacking")
	elif moving == true and attacking == true:
		animated_sprite.play("Run+Attacking")
	else:
		animated_sprite.play("Idle")
