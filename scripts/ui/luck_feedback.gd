extends Control
class_name LuckFeedback


@export var lucky:HBoxContainer
@export var good_anim_text:AnimatedLabel
@export var good_clover1:TextureRect
@export var good_clover2:TextureRect

@export var luck_up:HBoxContainer
@export var luck_up_text:AnimatedLabel
@export var luck_up_clover:TextureRect


@export var unlucky:HBoxContainer
@export var bad_anim_text:AnimatedLabel
@export var bad_clover1:TextureRect
@export var bad_clover2:TextureRect

@export var luck_down:HBoxContainer
@export var luck_down_text:AnimatedLabel
@export var luck_down_clover:TextureRect


@export var hide_timer:Timer


func show_feedback(goodluck:bool):
	if(goodluck):
		lucky.show()
		good_anim_text.animate_text("Good luck")
	if(!goodluck):
		unlucky.show()
		bad_anim_text.animate_text("Bad luck")
func hide_feedback():
	lucky.hide()
	good_clover2.hide()
	unlucky.hide()
	bad_clover2.hide()

func _on_goodluck_finished_animation() -> void:
	good_clover2.show()
	hide_timer.start()
func _on_badluck_finished_animation() -> void:
	bad_clover2.show()
	hide_timer.start()


func show_up_or_down(luckup:bool):
	if(luckup):
		luck_up.show()
		luck_up_text.animate_text("Luck up")
	if(!luckup):
		luck_down.show()
		luck_down_text.animate_text("Bad down")
func hide_up_or_down():
	luck_up.hide()
	luck_up_clover.hide()
	luck_down.hide()
	luck_down_clover.hide()

func _on_luckup_finished_animation() -> void:
	luck_up_clover.show()
	hide_timer.start()
func _on_luckdown_finished_animation() -> void:
	luck_down_clover.show()
	hide_timer.start()


func _on_hide_timer_timeout() -> void:
	hide_timer.stop()
	hide_feedback()
	hide_up_or_down()
