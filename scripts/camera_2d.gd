extends Camera2D

@export var player:Player

func _process(delta: float) -> void:
	if(!player.OBJECTIVES["ending"]): self.global_position = player.global_position
