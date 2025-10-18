extends Node2D
class_name EndingDoor

@export var event_handler:EventHandler
@export var player:Player
@export var maingame:Node2D
@export var camera:Camera2D

@onready var ending = preload("res://scenes/ending.tscn")

@export var bgsound:AudioStreamPlayer2D
@export var bgsound2:AudioStreamPlayer2D
@export var bgsound3:AudioStreamPlayer2D
@export var bgsound4:AudioStreamPlayer2D
@export var bgsound5:AudioStreamPlayer2D

func end():
	bgsound.stop()
	bgsound2.stop()
	bgsound3.stop()
	bgsound4.stop()
	bgsound5.play()
	player.show_feeback = false
	var instance:Ending = ending.instantiate()
	maingame.get_parent().add_child(instance)
	instance.global_position = Vector2(0, -166)
	instance.player = player
	instance.maingame = maingame
	instance.camera = camera
	instance.show_ending(false)

func _ready() -> void:
	event_handler.set_event_actions(end, end)
