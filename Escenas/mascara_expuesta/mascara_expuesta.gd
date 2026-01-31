extends Node2D

@export var mascara_num :int
@export var sprite: Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.completed_levels.get("level_"+str(mascara_num), false):
		sprite.show()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
