extends Node2D
class_name Door

@export var player:Player
@export var opacity:Opacity
@export var event_handler:EventHandler

@export var anim_closed:AnimatedSprite2D
@export var anim_closed_fallen:AnimatedSprite2D
@export var anim_open:AnimatedSprite2D
@export var anim_open_fallen:AnimatedSprite2D

@export var audio_effect:AudioStreamPlayer2D
@export var audio_effect2:AudioStreamPlayer2D
@export var audio_effect3:AudioStreamPlayer2D

func open_door():
	self.get_child(0).queue_free()
	self.get_child(1).show()
	audio_effect.play()

func good_event():
	opacity.handle_hide_opacity()
	open_door()
func bad_event():
	opacity.handle_hide_opacity()
	anim_closed.hide()
	audio_effect2.play()
	self.get_child(0).get_child(5).play("default")
	self.get_child(0).get_child(5).show()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
	self.get_child(0).get_child(4).player = player

func _on_falling_animation_finished() -> void:
	player.enter_cutscene()
	self.get_child(0).get_child(5).hide()
	self.get_child(0).get_child(4).hide()
	audio_effect2.stop()
	audio_effect3.play()
	anim_closed.hide()
	anim_closed_fallen.show()
	anim_closed_fallen.play("default")

func _on_fallen_door_animation_finished() -> void:
	anim_closed_fallen.hide()
	anim_open.hide()
	anim_open_fallen.show()
	anim_open_fallen.play("default")
	player.take_damage()
	player.exit_cutscene()
	open_door()
