extends Node2D
class_name Fridge

@export var player:Player
@export var handler:EventHandler

@export var fridge_anim:AnimatedSprite2D
@export var player_looking_at_fridge:AnimatedSprite2D

@export var look_at_fridge_timer:Timer
@export var stuck_at_fridge_timer:Timer
@export var close_automatically_timer:Timer

var good = false

@export var audioeffect1:AudioStreamPlayer2D
@export var audioeffect2:AudioStreamPlayer2D
@export var audioeffect3:AudioStreamPlayer2D


func good_event():
	if(player.OBJECTIVES["food"] or player.OBJECTIVES["cooked_food"]):
		player.show_feeback = false
		player.up_luck()
		player.dialogue.say_dialogue("I can't carry anymore food!", -1)
	else:
		player.OBJECTIVES["food"] = true
		good = true
		look_at_fridge()
func bad_event():
	if(player.OBJECTIVES["food"] or player.OBJECTIVES["cooked_food"]):
		player.show_feeback = false
		player.lower_luck()
		player.dialogue.say_dialogue("I can't carry anymore food!", -1)
	else:
		player.OBJECTIVES["food"] = true
		good = false
		look_at_fridge()

func _ready() -> void:
	handler.set_event_actions(good_event, bad_event)


func _process(delta: float) -> void:
	if(self.global_position.y>player.global_position.y): self.z_index = 1
	else: self.z_index = 0


func look_at_fridge():
	fridge_anim.play("open")
	audioeffect1.play()
	player.enter_cutscene()
	player_looking_at_fridge.show()
	look_at_fridge_timer.start()

func _on_look_at_fridge_timer_timeout() -> void:
	look_at_fridge_timer.stop()
	fridge_anim.play("closed")
	audioeffect2.play()
	player_looking_at_fridge.hide()
	if(good):
		player.exit_cutscene()
	else:
		stuck_at_fridge_timer.start()
		audioeffect3.play()

func _on_stuck_at_fridge_timer_timeout() -> void:
	stuck_at_fridge_timer.stop()
	player.make_cold()
	audioeffect1.play()
	fridge_anim.play("open")
	player.exit_cutscene()
	player.dialogue.say_dialogue("At least I still got the food...\nI better eat something hot.", 5)
	close_automatically_timer.start()

func _on_close_automatically_timeout() -> void:
	audioeffect2.play()
	close_automatically_timer.stop()
	fridge_anim.play("closed")
