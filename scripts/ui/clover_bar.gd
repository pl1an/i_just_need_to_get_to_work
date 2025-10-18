extends Node2D
class_name CloverBar


func set_cloverbar_item_state(state_name:String, item_index:int):
	var items:Array[Node] = self.get_children()
	items[item_index].play(state_name)
