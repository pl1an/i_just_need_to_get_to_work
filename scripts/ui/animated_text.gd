extends Label
class_name AnimatedLabel

signal finished_animation

var target_text:String
var counter:int = 0
var running:bool = false

@export var time_between_frames:float
var timer:float = 0


func _process(delta: float) -> void:
	if(running):
		timer += delta
		if(self.text == target_text or counter>=target_text.length()):
			running = false
			emit_signal("finished_animation")
		elif(timer>=time_between_frames):
			self.text = self.text + target_text[counter]
			counter = counter + 1
			timer = 0

func animate_text(target:String):
	self.text = ""
	counter = 0
	timer = 0
	target_text = target
	running = true
