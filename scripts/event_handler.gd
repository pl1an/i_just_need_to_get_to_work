extends Area2D
class_name EventHandler


@export var event_name:String
@export var good_event_action:Callable
@export var bad_event_action:Callable

var player:Player

var player_inside_radius = false
var ignore = false


# event code structure
# class_name event_name
# 
# @export var event_handler:EventHandler
# @export var player:Player
# 
# func good_event():
# 	pass
# func bad_event():
# 	pass
# 
# func _ready() -> void:
# 	event_handler.set_event_actions(good_event, bad_event)


func set_event_actions(good:Callable, bad:Callable):
	good_event_action = good
	bad_event_action = bad

func handle_choice(body:Node2D):
	if(body is Player):
		var choice = randi_range(1, 5)
		if(choice<=body.LUCK):
			print("lucky")
			body.handle_event(event_name, good_event_action, true)
		else:
			print("unlucky")
			body.handle_event(event_name, bad_event_action, false)

func ignore_subsequent(b:bool):
	ignore = b
	if(!ignore and player_inside_radius and player):
		handle_choice(player)

func _on_body_entered(body: Node2D) -> void:
	print(event_name, " entered")
	if(body is Player):
		player = body
		player_inside_radius = true
	if(!ignore):
		handle_choice(body)
func _on_body_exited(body: Node2D) -> void:
	print(event_name, " exited")
	if(body is Player):
		player_inside_radius = false
	if(body is Player and !ignore):
		body.event_ui.hide()
