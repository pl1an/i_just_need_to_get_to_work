extends Node2D
class_name Cabinet

@export var player:Player
@export var event_handler:EventHandler

@onready var burning_clothes = preload("res://scenes/forniture/burning_clothes.tscn")

@export var audio_effect:AudioStreamPlayer2D

func good_event():
	player.OBJECTIVES["tshirt"] = true
	event_handler.queue_free()
	audio_effect.play()
func bad_event():
	var instance:BurningClothes = burning_clothes.instantiate()
	add_child(instance)
	instance.global_position = self.global_position + Vector2(0, 80)
	instance.clothes_mode("tshirt")
	instance.player = player
	instance.ready_fire_timer()
	event_handler.queue_free()
	audio_effect.play()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
