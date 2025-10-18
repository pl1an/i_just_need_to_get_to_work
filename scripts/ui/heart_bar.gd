extends Node2D
class_name HeartBar

func set_health(health_value:int):
	var hearts = self.get_children()
	for i in range(health_value):
		hearts[i].show()
	for i in range(health_value, 5):
		hearts[i].hide()
