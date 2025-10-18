extends Node2D
class_name Bucket

@export var event_handler:EventHandler
@export var player:Player

func good_event():
	player.OBJECTIVES["bucket"] = true
	player.dialogue.say_dialogue("Now...\nWater!", -1)
	player.bucket_audio_effect.play()
	self.queue_free()
func bad_event():
	player.handle_bucket_on_head()
	self.queue_free()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
