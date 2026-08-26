extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager
@onready var health_bar: TextureProgressBar = $"Health Bar"
@onready var stamina_bar: TextureProgressBar = $"Stamina Bar"
@onready var dash_duration: Timer = $"Dash Duration"
@onready var title_screen: AnimatedSprite2D = $"../TitleScreen"

@export var dexterity = 1
@export var strength = 1
@export var stamina = 1

var max_stamina = stamina * 20
var current_stamina = max_stamina
var sprint = 1
var frozen = 0
var attacking: bool = false
var dash = 1
var move_speed = dexterity * 40

func _physics_process(delta):

#movement
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * move_speed * sprint * frozen * dash
	move_and_slide()

#sprint
	var sprinting := Input.is_action_pressed("sprint")
	if sprinting == true and current_stamina >= 0 and input_direction != Vector2(0,0):
		current_stamina -= delta * 10
		if current_stamina >= 1:
			sprint = 1.5
	else:
		sprint = 1
		if current_stamina <= max_stamina:
			current_stamina += delta * 5

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
	if attacking == false:
		if moving == true and game_manager.freezeAll == false:
			animated_sprite.play("Run")
		else:
			animated_sprite.play("Idle")
	if attacking == true:
		if moving == true and game_manager.freezeAll == false:
			animated_sprite.play("Run+Attacking")
		else:
			animated_sprite.play("Attacking")

#bars
	health_bar.value = game_manager.health
	stamina_bar.value = current_stamina
	stamina_bar.max_value = max_stamina

#dash
	if Input.is_action_just_pressed("dash") and current_stamina > 16:
		current_stamina = current_stamina - 15
		dash = 6
		dash_duration.start(0.1)

	if game_manager.game_overing == true:
		animated_sprite.play("Death")

func _process(_delta: float):
	if game_manager.mainMenu == true:
		position = title_screen.position


func _on_dash_duration_timeout() -> void:
	dash = 1
