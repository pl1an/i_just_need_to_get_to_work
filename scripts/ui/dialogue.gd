extends Control
class_name Dialogue

@export var dialogue_text:AnimatedLabel
@export var despawn_timer:Timer

signal dialogue_despawned
signal dialogue_typed

func say_dialogue(dialogue:String, despawn_time_seconds:float):
	self.show()
	dialogue_text.animate_text(dialogue)
	if(despawn_time_seconds==-1): despawn_timer.wait_time = 3
	else: despawn_timer.wait_time = despawn_time_seconds
	despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
	dialogue_text.text = ""
	emit_signal("dialogue_despawned")
	self.hide()

func _on_animated_label_finished_animation() -> void:
	emit_signal("dialogue_typed")
