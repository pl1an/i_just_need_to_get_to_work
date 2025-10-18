extends CharacterBody2D
class_name Player


@export var SPEED:float
@export var LUCK:int = 4
@export var HEALTH:int = 5

var badluck_counter = 0
@export var OBJECTIVES = {
	"tshirt":false,
	"pants":false,
	"ending":false,
	"bucket":false,
	"bucket_with_water":false,
	"bucket_on_head":false,
	"showered":false,
	"food":false,
	"cooked_food":false,
	"icy":false,
	"died":false,
	"sacrificied":false
}

@export var nav_agent:NavigationAgent2D
var finished = false
var target_pos:Vector2
signal ended_pathfinding

@export var anim_sprite:AnimatedSprite2D

var looking_at_event = false
var yes_function:Callable
@export var event_ui:Control

@export var luck_feedback:LuckFeedback
var show_feeback:bool = true
var show_up_or_down_feedback:bool = false
var luckup:bool = false

@export var luck_bar:CloverBar
var good_event:bool = false

@export var health_bar:HeartBar
@export var damage_overlay:DamageOverlay

@export var dialogue:Dialogue
var is_npc = false
var in_cutscene:bool = false
var showing_choices:bool = false

@export var death_overlay:DeathOverlay

@export var forniture:Node2D
@export var bucket_on_head:AnimatedSprite2D
@onready var bucket_preload = preload("res://scenes/forniture/bucket.tscn")

@export var smelly_lines:Node2D

@export var portal:Portal

@export var damage_audio_effect:AudioStreamPlayer2D

@export var bucket_audio_effect:AudioStreamPlayer2D
@export var bucket_audio_effect2:AudioStreamPlayer2D

@export var bgsound:AudioStreamPlayer2D
@export var bgsound2:AudioStreamPlayer2D
@export var bgsound3:AudioStreamPlayer2D
@export var bgsound4:AudioStreamPlayer2D
@export var bgsound5:AudioStreamPlayer2D


func _physics_process(delta: float) -> void:
	# handling movement
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction*SPEED
	if(OBJECTIVES["icy"]): velocity = velocity/2
	if(finished or in_cutscene): velocity = Vector2.ZERO
	# handling animations
	choose_animation()
	# moving
	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event.is_action("move") and !looking_at_event and !in_cutscene and !OBJECTIVES["ending"] and !is_npc):
		event_ui.hide()
		finished = false
		target_pos = get_global_mouse_position()
		find_path()

func find_path() -> void:
	nav_agent.target_position = target_pos
func _on_navigation_agent_2d_navigation_finished() -> void:
	emit_signal("ended_pathfinding")
	finished = true


func handle_event(event_name:String, updated_yes_function:Callable, good:bool) -> void:
	good_event = good
	event_ui.show()
	showing_choices = true
	yes_function = updated_yes_function
	var title:AnimatedLabel = event_ui.get_child(0).get_child(2)
	title.animate_text(event_name)

func _on_nobutton_pressed() -> void:
	event_ui.hide()
	showing_choices = false
func _on_yesbutton_pressed() -> void:
	event_ui.hide()
	showing_choices = false
	if(good_event):
		lower_luck()
	else:
		if(show_feeback): badluck_counter = badluck_counter + 1
		if(badluck_counter>=5 and !portal.activated):
			portal.activate_portal()
			dialogue.say_dialogue("What was that?", -1)
		up_luck()
	yes_function.call()
	if(show_feeback): luck_feedback.show_feedback(good_event)
	if(!show_feeback): show_feeback = true
	if(show_up_or_down_feedback): luck_feedback.show_up_or_down(luckup)
	if(show_up_or_down_feedback): show_up_or_down_feedback = false

func _on_texture_rect_mouse_entered() -> void:
	looking_at_event = true
func _on_texture_rect_mouse_exited() -> void:
	looking_at_event = false


func die():
	bgsound.stop()
	bgsound2.stop()
	bgsound3.stop()
	bgsound4.stop()
	bgsound5.play()
	OBJECTIVES["ending"] = true
	OBJECTIVES["died"] = true
	damage_overlay.play_death_anim()
	death_overlay.show_death()

func lower_luck():
	if(LUCK>1):
		LUCK = LUCK - 1
		luck_bar.set_cloverbar_item_state("bad_luck", LUCK)
func up_luck():
	if(LUCK<4):
		LUCK = LUCK + 1
		luck_bar.set_cloverbar_item_state("luck", LUCK - 1)

func take_damage():
	HEALTH = HEALTH - 1
	if(HEALTH<=0):
		die()
		return
	damage_audio_effect.play()
	if(HEALTH<=2):
		dialogue.say_dialogue("I should eat something...", 4)
	health_bar.set_health(HEALTH)
	damage_overlay.play_damage_anim()
func heal():
	if(HEALTH==5): return
	HEALTH = HEALTH + 1
	health_bar.set_health(HEALTH)
	damage_overlay.play_heal_anim()

func enter_cutscene():
	anim_sprite.get_parent().hide()
	in_cutscene = true
func exit_cutscene():
	anim_sprite.get_parent().show()
	in_cutscene = false

func hide_bars():
	health_bar.hide()
	luck_bar.hide()
func show_bars():
	health_bar.show()
	luck_bar.show()

func make_cold():
	OBJECTIVES["icy"] = true
	anim_sprite.self_modulate = Color.AQUA
func make_not_cold():
	OBJECTIVES["icy"] = false
	anim_sprite.self_modulate = Color.WHITE

func explode():
	damage_overlay.play_explode_anim()
	make_not_cold()


func choose_animation():
	if(OBJECTIVES["bucket_on_head"]): return
	# handling idle animation
	if(velocity==Vector2.ZERO):
		if(is_npc):
			anim_sprite.play("npc_idle_back")
		elif(OBJECTIVES["ending"]):
			if(OBJECTIVES["tshirt"] and OBJECTIVES["pants"]): anim_sprite.play("idleback_full")
			elif(OBJECTIVES["tshirt"]): anim_sprite.play("idleback_shirt")
			elif(OBJECTIVES["pants"]): anim_sprite.play("idleback_pants")
			else: anim_sprite.play("idleback_none")
		else:
			if(OBJECTIVES["tshirt"] and OBJECTIVES["pants"]): anim_sprite.play("idle_full")
			elif(OBJECTIVES["tshirt"]): anim_sprite.play("idle_shirt")
			elif(OBJECTIVES["pants"]): anim_sprite.play("idle_pants")
			else: anim_sprite.play("idle_none")
	# handling side run animation
	elif(abs(velocity.x)>=abs(velocity.y)):
		if(velocity.x>0 and anim_sprite.get_parent().scale.x>0): anim_sprite.get_parent().scale.x = -anim_sprite.get_parent().scale.x
		if(velocity.x<0 and anim_sprite.get_parent().scale.x<0): anim_sprite.get_parent().scale.x = -anim_sprite.get_parent().scale.x
		if(is_npc):
			anim_sprite.play("npc_side")
		else:
			if(OBJECTIVES["tshirt"] and OBJECTIVES["pants"]): anim_sprite.play("side_full")
			elif(OBJECTIVES["tshirt"]): anim_sprite.play("side_shirt")
			elif(OBJECTIVES["pants"]): anim_sprite.play("side_pants")
			else: anim_sprite.play("side_none")
	# handling upwards or downwards run animation
	elif(abs(velocity.y)>abs(velocity.x)): 
		if(velocity.y>0):
			if(OBJECTIVES["tshirt"] and OBJECTIVES["pants"]): anim_sprite.play("forward_full")
			elif(OBJECTIVES["tshirt"]): anim_sprite.play("forward_shirt")
			elif(OBJECTIVES["pants"]): anim_sprite.play("forward_pants")
			else: anim_sprite.play("forward_none")
		else:
			if(OBJECTIVES["tshirt"] and OBJECTIVES["pants"]): anim_sprite.play("backward_full")
			elif(OBJECTIVES["tshirt"]): anim_sprite.play("backward_shirt")
			elif(OBJECTIVES["pants"]): anim_sprite.play("backward_pants")
			else: anim_sprite.play("backward_none")


# event functions

func handle_bucket_on_head():
	OBJECTIVES["bucket_on_head"] = true
	bucket_on_head.show()
	anim_sprite.stop()
	if(anim_sprite.get_parent().scale.x<0): anim_sprite.get_parent().scale.x = -anim_sprite.get_parent().scale.x
	in_cutscene = true
	bucket_on_head.get_child(0).play("player_falling")
func handle_getting_bucket_off_head():
	bucket_audio_effect2.play()
	OBJECTIVES["bucket_on_head"] = false
	in_cutscene = false
	bucket_on_head.hide()
	take_damage()
	anim_sprite.get_parent().rotation = 0
	var instance:Bucket = bucket_preload.instantiate()
	forniture.add_child(instance)
	instance.global_position = Vector2(378, 390)
	instance.player = self
	instance.scale = instance.scale*0.4
	
	
