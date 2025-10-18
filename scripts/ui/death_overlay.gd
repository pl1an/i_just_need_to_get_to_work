extends Control
class_name DeathOverlay

@export var death_text:AnimatedLabel
@export var ending_timer:Timer

@export var maingame:Node2D
@export var player:Player
@export var camera:Camera2D
@onready var ending = preload("res://scenes/ending.tscn")

func show_death():
	player.luck_feedback.hide()
	player.event_ui.hide()
	player.dialogue.hide()
	death_text.show()
	death_text.animate_text("BAD LUCK")
	ending_timer.start()

func _on_switch_to_ending_timer_timeout() -> void:
	ending_timer.stop()
	death_text.hide()
	player.damage_overlay.hide()
	var instance:Ending = ending.instantiate()
	maingame.get_parent().add_child(instance)
	instance.global_position = Vector2(0, -166)
	instance.player = player
	instance.maingame = maingame
	instance.camera = camera
	instance.show_ending(true)
