extends Node2D
class_name Stove

@export var event_handler:EventHandler
@export var player:Player

var good = false

@export var stove_body:AnimatedSprite2D
@export var cooking_timer:Timer
@export var fires_container:Node2D

@export var audioeffect1:AudioStreamPlayer2D
@export var audioeffect2:AudioStreamPlayer2D

func good_event():
	good = true
	if(!player.OBJECTIVES["food"]):
		player.show_feeback = false
		player.up_luck()
		player.dialogue.say_dialogue("I have nothing to heat up.", 4)
	elif(player.OBJECTIVES["cooked_food"]):
		player.show_feeback = false
		player.up_luck()
		player.dialogue.say_dialogue("If I heat it up more\nit will get burned...", 5)
	else:
		cook()
func bad_event():
	good = false
	if(!player.OBJECTIVES["food"]):
		player.show_feeback = false
		player.lower_luck()
		player.dialogue.say_dialogue("I have nothing to heat up.", 4)
	elif(player.OBJECTIVES["cooked_food"]):
		player.show_feeback = false
		player.lower_luck()
		player.dialogue.say_dialogue("If I heat it up more\nit will get burned...", 5)
	else:
		cook()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)
	for i in fires_container.get_children():
		if(i is BurningClothes):
			i.extinguish_event_handler.ignore_subsequent(true)
			i.pickup_event_handler.ignore_subsequent(true)
			i.player = player

func cook():
	player.in_cutscene = true
	player.OBJECTIVES["ending"] = true
	player.OBJECTIVES["food"] = false
	player.OBJECTIVES["cooked_food"] = true
	player.global_position = self.global_position - Vector2(0, -60)
	cooking_timer.start()
	audioeffect1.play()
func stop_cooking():
	audioeffect1.stop()
	player.in_cutscene = false
	player.OBJECTIVES["ending"] = false
	cooking_timer.stop()

func _on_cooking_timer_timeout() -> void:
	stop_cooking()
	if(!good):
		audioeffect2.play()
		player.explode()
		event_handler.queue_free()
		stove_body.play("destroyed")
		fires_container.show()
		for i in fires_container.get_children():
			if(i is BurningClothes):
				i.can_be_picked_up = false
				i.clothes_body.play("invisible")
				i.start_fire()
