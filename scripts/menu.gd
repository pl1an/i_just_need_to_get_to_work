extends Control
class_name Menu

@export var player:Player

@export var main_menu:VBoxContainer
@export var animated_title:AnimatedLabel
@export var animated_subtitle:AnimatedLabel
@export var animated_subtitle2:AnimatedLabel
@export var animated_start:TextureButton
@export var animated_how:TextureButton

@export var how_menu:VBoxContainer
@export var instructions1:AnimatedLabel
@export var instructions2:AnimatedLabel
@export var instructions3:AnimatedLabel
@export var instructions4:AnimatedLabel
@export var animated_back:TextureButton

@export var bed:Bed

@export var bgaudio1:AudioStreamPlayer2D
@export var bgaudio2:AudioStreamPlayer2D


func _ready() -> void:
	player.hide_bars()
	animated_title.animate_text("I just need to get to work.")
	bgaudio2.play()


func _on_texture_button_pressed() -> void:
	player.show_bars()
	bed.get_out_timer.start()
	bgaudio2.stop()
	bgaudio1.play()
	self.queue_free()

func _on_animated_label_finished_animation() -> void:
	animated_subtitle.animate_text("That's it.")
func _on_animated_label_3_finished_animation() -> void:
	animated_start.show()
	animated_how.show()
func _on_animated_label_2_finished_animation() -> void:
	animated_subtitle2.animate_text("There's no way anything goes wrong.")


func _on_texture_button_2_pressed() -> void:
	main_menu.hide()
	how_menu.show()
	instructions1.animate_text("Click on the screen to move.")

func _on_instructions_finished_animation() -> void:
	instructions2.animate_text("Get close to objects to interact\nwith them.\n")
func _on_instructions_2_finished_animation() -> void:
	instructions3.animate_text("Each interaction can be successuful\nor not, depending on your luck.\n")
func _on_instructions_3_finished_animation() -> void:
	instructions4.animate_text("Successful interactions reduce luck,\nwhile unsuccessful ones raise it.")
func _on_instructions_4_finished_animation() -> void:
	animated_back.show()

func _on_texture_button_3_pressed() -> void:
	instructions1.text = ""
	instructions2.text = ""
	instructions3.text = ""
	instructions4.text = ""
	animated_back.hide()
	how_menu.hide()
	main_menu.show()
