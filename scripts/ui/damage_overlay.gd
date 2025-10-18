extends Control
class_name DamageOverlay

@export var anim:AnimationPlayer

func play_damage_anim():
	anim.play("take_damage")

func play_heal_anim():
	anim.play("heal")

func play_explode_anim():
	anim.play("explode")

func play_death_anim():
	anim.play("death")
