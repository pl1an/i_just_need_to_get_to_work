extends Node2D
class_name KitchenSink

@export var event_handler:EventHandler
@export var player:Player

@export var audio_effect:AudioStreamPlayer2D
@export var audio_effect2:AudioStreamPlayer2D

func good_event():
	if(player.OBJECTIVES["bucket_with_water"]):
		player.show_feeback = false
		player.dialogue.say_dialogue("I can't fill it anymore!", -1)
		player.up_luck()
	elif(player.OBJECTIVES["bucket"]):
		player.OBJECTIVES["bucket_with_water"] = true
		audio_effect.play()
	else:
		player.show_feeback = false
		player.dialogue.say_dialogue("I need something to\ncarry the water first...", 4)
		player.up_luck()
func bad_event():
	if(player.OBJECTIVES["bucket_with_water"]):
		player.show_feeback = false
		player.dialogue.say_dialogue("I can't fill it anymore!", -1)
		player.lower_luck()
	elif(player.OBJECTIVES["bucket"]):
		var instance:Bucket = player.bucket_preload.instantiate()
		player.forniture.add_child(instance)
		instance.global_position = Vector2(378, 297)
		instance.player = player
		instance.scale = instance.scale*0.4
		player.OBJECTIVES["bucket"] = false
		player.dialogue.say_dialogue("God damn it!\nI dropped the bucket!", 4)
		audio_effect2.play()
	else:
		player.show_feeback = false
		player.dialogue.say_dialogue("I need something to\ncarry the water first...", 4)
		player.lower_luck()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
