extends CharacterBody2D

@export var move_speed : float = 40
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var title_screen: AnimatedSprite2D = $"../TitleScreen"
var sprint = 1
var frozen = 0
var attacking: bool = false

#movement
func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	velocity = input_direction * move_speed * sprint * frozen
	move_and_slide()

#sprint
	var sprinting := Input.is_action_pressed("sprint")
	if sprinting == true:
		sprint = 1.5
	else:
		sprint = 1
	

#sprite direction
	var Xdirection := Input.get_axis("left", "right")
	var Ydirection := Input.get_axis("up", "down")
	
	if Xdirection > 0 and game_manager.freezeAll == false:
		animated_sprite.flip_h = false
	elif Xdirection < 0 and game_manager.freezeAll == false:
		animated_sprite.flip_h = true

#freeze
	if game_manager.freezeAll == true:
		frozen = 0
	else:
		frozen = 1

#attack code
	if Input.is_action_just_pressed("attack"):
		attacking = true
	elif  Input.is_action_just_released("attack"):
		attacking = false
	var moving : bool
	if Xdirection != 0 or Ydirection != 0:
		moving = true
	else:
		moving = false

#movement animation
	if moving == true and game_manager.freezeAll == false:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

func _process(_delta: float):
	if game_manager.mainMenu == true:
		position = title_screen.position
