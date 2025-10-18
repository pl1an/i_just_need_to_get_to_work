extends Node2D
class_name BurningClothes


var clothes_name:String

var player_out = true
var burning = false

@export var clothes_body:AnimatedSprite2D
@export var fire_anim:AnimationPlayer

@export var player:Player
@export var extinguish_event_handler:EventHandler
@export var pickup_event_handler:EventHandler

var can_be_picked_up:bool = true

@export var audioeffect:AudioStreamPlayer2D
@export var audioeffect2:AudioStreamPlayer2D
@export var audioeffect3:AudioStreamPlayer2D
@export var audioeffect4:AudioStreamPlayer2D


func good_extinguish_event():
	if(player.OBJECTIVES["bucket_with_water"]):
		player.OBJECTIVES["bucket_with_water"] = false
		extinguish_fire()
	elif(!player.OBJECTIVES["bucket_with_water"]):
		player.dialogue.say_dialogue("I don't have anything\nto extinguish it with...", 5)
		player.up_luck()
func bad_extinguish_event():
	if(player.OBJECTIVES["bucket_with_water"]):
		player.OBJECTIVES["bucket_with_water"] = false
		player.dialogue.say_dialogue("The water wasn't enough!\nI need more!", 4)
	elif(!player.OBJECTIVES["bucket_with_water"]):
		player.dialogue.say_dialogue("I don't have anything\nto extinguish it with...", 5)
		player.lower_luck()

func good_pickup_event():
	player.OBJECTIVES[clothes_name] = true
	self.queue_free()
	audioeffect3.play()
func bad_pickup_event():
	pickup_event_handler.ignore_subsequent(true)
	start_fire()

func _ready() -> void:
	extinguish_event_handler.set_event_actions(good_extinguish_event, bad_extinguish_event)
	pickup_event_handler.set_event_actions(good_pickup_event, bad_pickup_event)

func ready_fire_timer():
	audioeffect2.play()
	extinguish_event_handler.ignore_subsequent(true)
	pickup_event_handler.ignore_subsequent(true)
	fire_anim.play("start_fire")
func ready_pick_up():
	audioeffect2.play()
	extinguish_event_handler.ignore_subsequent(true)
	pickup_event_handler.ignore_subsequent(false)

func start_fire():
	audioeffect.play()
	self.get_child(1).show()
	self.get_child(2).show()
	burning = true
	if(player_out==false): player.take_damage()
	extinguish_event_handler.ignore_subsequent(false)
func extinguish_fire():
	audioeffect4.play()
	audioeffect.stop()
	self.get_child(1).hide()
	self.get_child(2).hide()
	burning = false
	extinguish_event_handler.ignore_subsequent(true)
	if(can_be_picked_up): pickup_event_handler.ignore_subsequent(false)

func clothes_mode(name:String):
	clothes_name = name
	if(name=="tshirt"): clothes_body.play("tshirt")
	if(name=="pants"): clothes_body.play("pants")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		player_out = false
		player = body
	if(body is Player and burning):
		body.take_damage()
func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		player_out = true
