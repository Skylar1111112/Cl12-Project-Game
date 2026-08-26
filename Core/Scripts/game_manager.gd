extends Node

var health = 100
var freezeAll = true
@onready var health_label: Label = $"../Player/Health_Label"
@onready var pause_timer: Timer = $"Pause button"
@onready var pause_screen: AnimatedSprite2D = $"../Player/Pause_Screen"
@onready var title_screen: AnimatedSprite2D = $"../TitleScreen"
@onready var game_over: Timer = $"Game Over"
@onready var game: Node2D = $".."

var buttonTimer = false
var mainMenu = true
var paused = false
var game_overing = false

#menu change and reset the game
func main_menu_change():
	if mainMenu == true:
		mainMenu = false
		paused = false
		freezeAll = true
		pause_screen.play("Disabled")
		health = 100
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
		pause_timer.start()
		pause_screen.play("Enabled")
	elif pause == true and paused == true and buttonTimer == false and mainMenu == false:
		freezeAll = false
		buttonTimer = true
		paused = false
		pause_timer.start()
		pause_screen.play("Disabled")

#player is hit
func damage_player(x):
	if freezeAll == false:
		health -= x
		pass
	if health <= 0 or health == 0:
		if game_overing == false:
			game_overing = true
			game_over.start(2)
		freezeAll = true
	else:
		health_label.text = "Health = " + str(health) +""

func _on_game_over_timeout():
	get_tree().reload_current_scene()
	
#intro
func _on_title_screen_animation_finished() -> void:
	if title_screen.animation == "Intro":
		health_label.text = "Health = " + str(health) +""
		freezeAll = false
