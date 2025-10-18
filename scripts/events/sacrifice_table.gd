extends Node2D
class_name SacrificeTable

@export var event_handler:EventHandler
@export var player:Player

@export var table:AnimatedSprite2D
@export var darkness: Sprite2D
@export var dagger:AnimatedSprite2D

@export var open_eyes_layer:TileMapLayer
@export var return_portal:Portal
@export var torch1:AnimatedSprite2D
@export var torch2:AnimatedSprite2D

@export var audio_effect:AudioStreamPlayer2D
@export var bgaudio4:AudioStreamPlayer2D

func good_event():
	player.up_luck()
	player.up_luck()
	sacrifice()
func bad_event():
	sacrifice()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)

func sacrifice():
	audio_effect.play()
	bgaudio4.play()
	player.OBJECTIVES["sacrificied"] = true
	player.show_feeback = false
	player.show_up_or_down_feedback = true
	player.luckup = true
	player.take_damage()
	darkness.hide()
	table.play("blody")
	dagger.play("blody")
	open_eyes_layer.show()
	return_portal.activate_portal()
	torch1.play("lit_up")
	torch2.play("lit_up")
