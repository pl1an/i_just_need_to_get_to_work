extends Node2D
class_name Bed

@export var player:Player
@export var event_handler:EventHandler
@export var get_out_timer:Timer

@export var audio_effect:AudioStreamPlayer2D

func good_event():
	event_handler.queue_free()
	get_out_timer.queue_free()
	player.exit_cutscene()
	player.dialogue.say_dialogue("Ugh...\nI need a bath.", -1)
	self.get_child(0).play("out_of_bed")
	audio_effect.play()
func bad_event():
	player.dialogue.say_dialogue("No...\nJust five more minutes...", -1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.enter_cutscene()
	event_handler.set_event_actions(good_event, bad_event)

func _on_get_out_timer_timeout() -> void:
	if(not player.showing_choices): event_handler.handle_choice(player)
	get_out_timer.start()
