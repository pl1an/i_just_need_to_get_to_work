extends Node2D
class_name Shower

@export var event_handler:EventHandler
@export var player:Player
@export var shower_timer:Timer

var good = false

@export var player_inside_shower:AnimatedSprite2D
@export var shower_anim:AnimatedSprite2D

@onready var burning_clothes = preload("res://scenes/forniture/burning_clothes.tscn")

@export var audio_effect:AudioStreamPlayer2D
@export var audio_effect2:AudioStreamPlayer2D


func good_event():
	good = true
	enter_shower()
func bad_event():
	good = false
	enter_shower()
	
func take_off_clothes():
	if(player.OBJECTIVES["tshirt"]):
		var instance:BurningClothes = burning_clothes.instantiate()
		add_child(instance)
		instance.global_position = Vector2(323, 76)
		instance.rotation = -90
		instance.scale = Vector2(2, 2)
		instance.clothes_mode("tshirt")
		instance.player = player
		instance.ready_pick_up()
		player.OBJECTIVES["tshirt"] = false
	if(player.OBJECTIVES["pants"]):
		var instance:BurningClothes = burning_clothes.instantiate()
		add_child(instance)
		instance.global_position = Vector2(315, 65)
		instance.rotation = 0
		instance.scale = Vector2(3, 3)
		instance.clothes_mode("pants")
		instance.player = player
		instance.ready_pick_up()
		player.OBJECTIVES["pants"] = false
	
func enter_shower():
	audio_effect.play()
	if(player.OBJECTIVES["icy"]): player.make_not_cold()
	player.enter_cutscene()
	take_off_clothes()
	shower_anim.play("showering")
	player_inside_shower.show()
	player_inside_shower.play("default")
	player.OBJECTIVES["showered"] = true
	player.smelly_lines.hide()
	shower_timer.start()
func exit_shower():
	audio_effect.stop()
	player.exit_cutscene()
	shower_anim.play("default")
	player_inside_shower.hide()

func _ready() -> void:
	event_handler.set_event_actions(good_event, bad_event)

func _on_shower_timer_timeout() -> void:
	shower_timer.stop()
	if(good):
		exit_shower()
	else:
		audio_effect2.play()
		player_inside_shower.play("shock")

func _on_player_inside_shower_animation_finished() -> void:
	if(player_inside_shower.animation=="shock"):
		player_inside_shower.stop()
		player.take_damage()
		exit_shower()
