extends Node2D
class_name Table

@export var event_handler:EventHandler
@export var player:Player

@export var audioeffect1:AudioStreamPlayer2D

func good_event():
	player.up_luck()
	eat()
func bad_event():
	player.lower_luck()
	eat()

func eat():
	player.show_feeback = false
	if(player.OBJECTIVES["cooked_food"]):
		player.heal()
		player.heal()
		player.OBJECTIVES["cooked_food"] = false
		player.make_not_cold()
		audioeffect1.play()
	elif(player.OBJECTIVES["food"]):
		player.heal()
		player.OBJECTIVES["food"] = false
		audioeffect1.play()
	else:
		player.dialogue.say_dialogue("I have nothing to eat\non me right now.", 4)

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
