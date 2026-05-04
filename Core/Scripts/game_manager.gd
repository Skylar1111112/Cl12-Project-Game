extends Node

var Health = 30
var freezeAll = true
@onready var health_label: Label = $"../Player/Health_Label"
@onready var timer: Timer = $"Pause button"
@onready var pause_screen: AnimatedSprite2D = $"../Player/Pause_Screen"
@onready var title_screen: AnimatedSprite2D = $"../TitleScreen"

var buttonTimer = false
var mainMenu = true
var paused = false

func main_menu_change():
	if mainMenu == true:
		mainMenu = false
		paused = false
		pause_screen.play("Disabled")
		Health = 30
	elif mainMenu == false:
		mainMenu = true
		paused = false
		pause_screen.play("Disabled")

func _on_pause_button_timeout() -> void:
	buttonTimer = false

#pause
func _physics_process(_delta):
	var pause := Input.is_action_pressed("Pause")
	if pause == true and paused == false and buttonTimer == false and mainMenu == false:
		freezeAll = true
		buttonTimer = true
		paused = true
		timer.start()
		pause_screen.play("Enabled")
	elif pause == true and paused == true and buttonTimer == false and mainMenu == false:
		freezeAll = false
		buttonTimer = true
		paused = false
		timer.start()
		pause_screen.play("Disabled")

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
