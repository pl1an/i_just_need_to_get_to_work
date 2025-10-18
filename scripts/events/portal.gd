extends Node2D
class_name Portal

@export var return_portal = false
var activated = false

@export var event_handler:EventHandler
@export var player:Player

@export var audio_effect:AudioStreamPlayer2D
@export var audio_effect2:AudioStreamPlayer2D
@export var bgaudio1:AudioStreamPlayer2D
@export var bgaudio2:AudioStreamPlayer2D
@export var bgaudio4:AudioStreamPlayer2D


func good_event():
	player.show_feeback = false
	player.up_luck()
	enter_portal()
func bad_event():
	player.show_feeback = false
	player.lower_luck()
	enter_portal()
	
func enter_portal():
	if(!return_portal):
		player.global_position = Vector2(946, -1450)
		bgaudio1.stop()
		bgaudio2.play()
		if(player.OBJECTIVES["sacrificied"]): bgaudio4.play()
	else:
		player.global_position = Vector2.ZERO
		bgaudio1.play()
		bgaudio2.stop()
		bgaudio4.stop()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
	event_handler.ignore_subsequent(true)

func activate_portal():
	self.show()
	audio_effect.play()
	audio_effect2.play()
	event_handler.ignore_subsequent(false)
	activated = true
