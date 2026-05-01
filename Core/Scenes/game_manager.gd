extends Node

var Health = 30
var freezeAll = true
@onready var health_label: Label = $"../Player/Health_Label"
@onready var timer: Timer = $"Pause button"
@onready var animated_sprite: AnimatedSprite2D = $"../Player/Pause_Screen"
@onready var title_screen: AnimatedSprite2D = $"../Player/TitleScreen"

var buttonTimer = false
var mainMenu = true

func main_menu_change():
	if mainMenu == true:
		mainMenu = false
	elif mainMenu == false:
		mainMenu = true

func _on_pause_button_timeout() -> void:
	buttonTimer = false

#pause
func _physics_process(_delta):
	var pause := Input.is_action_pressed("Pause")
	if pause == true and freezeAll == false and buttonTimer == false:
		freezeAll = true
		buttonTimer = true
		timer.start()
		animated_sprite.play("Enabled")
	elif pause == true and freezeAll == true and buttonTimer == false:
		freezeAll = false
		buttonTimer = true
		timer.start()
		animated_sprite.play("Disabled")

#player is hit
func damage_player():
	if freezeAll == false:
		Health -= 1
	if Health < 0:
		pass # trigger game over
	else:
		health_label.text = "Health = " + str(Health) +""

#intro
func _on_title_screen_animation_finished() -> void:
	if title_screen.animation == "Intro":
		health_label.text = "Health = " + str(Health) +""
		freezeAll = false
