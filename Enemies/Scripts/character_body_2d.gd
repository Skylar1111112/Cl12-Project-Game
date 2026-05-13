extends CharacterBody2D
@onready var parent: CharacterBody2D = $"../Thistle Thrower"
var initial = true
var player = null
var movespeed = 40

#func _process(_delta):
#	if parent.player != null:
#		player = parent.player
#		velocity = position.direction_to(player.position) * movespeed

#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
