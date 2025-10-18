extends Node2D
class_name Ending


@export var player:Player

@export var camera:Camera2D
@export var maingame:Node2D

@export var dialogue_start_timer:Timer
@export var boss_dialogue_start_timer:Timer

@export var boss_dialogue:Dialogue
var boss_dialogue_counter = 0
var max_boss_dialogue = 1

@export var restart_overlay:Control
var good_ending = false
var finished_typing_ending = false


func show_ending(secretary:bool):
	camera.global_position = Vector2(0, -60)
	maingame.queue_free()
	self.show()
	player.is_npc = secretary
	if(secretary): player.smelly_lines.hide()
	player.hide_bars()
	player.OBJECTIVES["ending"] = true
	player.global_position = Vector2(-756, 240)
	player.finished = false
	player.target_pos = Vector2(5, 240)
	player.find_path()
	dialogue_start_timer.start()


func _on_dialogue_start_timer_timeout() -> void:
	dialogue_start_timer.stop()
	var choice = choose_player_dialogue()
	print(choice)
	if(choice[0]!=""):
		player.dialogue.say_dialogue(choice[0], choice[1])
		boss_dialogue_start_timer.start()
	else:
		choice = choose_boss_dialogue()
		boss_dialogue.say_dialogue(choice[0], choice[1])
func _on_boss_dialogue_start_timer_timeout() -> void:
	boss_dialogue_start_timer.stop()
	var choice = choose_boss_dialogue()
	boss_dialogue.say_dialogue(choice[0], choice[1])


func choose_player_dialogue():
	var dialogue_text = ""
	var dialogue_time = 0
	if(player.OBJECTIVES["died"]):
		dialogue_text = "Sir, he was found dead in his home.\nThat's why he didn't came today."
		dialogue_time = 5
	return [dialogue_text, dialogue_time]

func choose_boss_dialogue():
	var dialogue_text = ""
	var dialogue_time = 0
	boss_dialogue_counter = boss_dialogue_counter + 1
	if(player.OBJECTIVES["died"]):
		dialogue_text = "Damn... That's sad.\nI was going to promote him\ntoday."
		dialogue_time = 4
		good_ending = false
	elif(player.OBJECTIVES["tshirt"] and player.OBJECTIVES["pants"] and player.OBJECTIVES["showered"]):
		dialogue_text = "Congratulations!\nI've been wanting to tell you\nall morning!\nYou are promoted!"
		dialogue_time = 7
		good_ending = true
	elif(!player.OBJECTIVES["tshirt"] and player.OBJECTIVES["pants"] and player.OBJECTIVES["showered"]):
		dialogue_text = "Where the hell is your shirt?\nGET OUT!"
		dialogue_time = 5
		good_ending = false
	elif(player.OBJECTIVES["tshirt"] and !player.OBJECTIVES["pants"] and player.OBJECTIVES["showered"]):
		dialogue_text = "Where the hell are your pants?\nDid you lost your mind?\nGET OUT!"
		dialogue_time = 7
		good_ending = false
	elif(!player.OBJECTIVES["tshirt"] and !player.OBJECTIVES["pants"] and player.OBJECTIVES["showered"]):
		dialogue_text = "Why are you only in your underwear?\nGET OUT!\nYou are fired!\nI DON'T WANT TO SEE YOU EVER AGAIN"
		dialogue_time = 10
		good_ending = false
	elif(player.OBJECTIVES["tshirt"] and player.OBJECTIVES["pants"] and !player.OBJECTIVES["showered"]):
		dialogue_text = "Congrutalations!\nI've been...\nWait. What the hell is this smell?\nYOU DON'T SHOWER? GET OUT!"
		dialogue_time = 10
		good_ending = false
	elif((!player.OBJECTIVES["tshirt"] and !player.OBJECTIVES["showered"]) or (!player.OBJECTIVES["pants"] and !player.OBJECTIVES["showered"]) or (!player.OBJECTIVES["tshirt"] and !player.OBJECTIVES["pants"] and !player.OBJECTIVES["showered"])):
		dialogue_text = "What is this...\nYou smell, and aren't even dressed properly.\nDON'T EVER COME BACK TO MY COMPANY.\nYou're a pathetic excuse for a human being."
		dialogue_time = 13
		good_ending = false
	return [dialogue_text, dialogue_time]


func _on_dialogue_dialogue_despawned() -> void:
	if(max_boss_dialogue >= boss_dialogue_counter):
		restart_overlay.show()
		if(good_ending and !finished_typing_ending):
			restart_overlay.get_child(0).get_child(0).show()
			restart_overlay.get_child(0).get_child(0).animate_text("Good ending")
		elif(!finished_typing_ending):
			restart_overlay.get_child(0).get_child(1).show()
			restart_overlay.get_child(0).get_child(1).animate_text("Bad ending")
	else:
		var choice = choose_boss_dialogue()
		boss_dialogue.say_dialogue(choice[0], choice[1])


func _on_texture_button_pressed() -> void:
	self.get_tree().reload_current_scene()
func _on_goodending_finished_animation() -> void:
	finished_typing_ending = true
func _on_badending_finished_animation() -> void:
	finished_typing_ending = true
