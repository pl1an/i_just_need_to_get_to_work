extends Node2D
class_name Drawer

@export var event_handler:EventHandler
@export var player:Player

@onready var burning_clothes = preload("res://scenes/forniture/burning_clothes.tscn")

@export var audio_effect:AudioStreamPlayer2D

func good_event():
	player.OBJECTIVES["pants"] = true
	event_handler.queue_free()
	audio_effect.play()
func bad_event():
	var instance:BurningClothes = burning_clothes.instantiate()
	self.add_child(instance)
	instance.clothes_mode("pants")
	instance.global_position = self.global_position + Vector2(60, 40)
	instance.player = player
	instance.ready_fire_timer()
	event_handler.queue_free()
	audio_effect.play()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
