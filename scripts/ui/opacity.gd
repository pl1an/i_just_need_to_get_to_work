extends TextureRect
class_name Opacity

@export var player:Player
@export var anim:AnimationPlayer

func handle_hide_opacity():
	anim.play("hide_opacity")
func hide_opacity():
	self.hide()

func _on_mouse_entered() -> void:
	player.looking_at_event = true
func _on_mouse_exited() -> void:
	player.looking_at_event = false
