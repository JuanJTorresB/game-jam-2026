extends Node2D

@export var mascara_num :int
@export var sprite: Sprite2D
@export var mascara_1_png: Texture
@export var mascara_2_png: Texture
@export var mascara_3_png: Texture
@export var mascara_4_png: Texture
@export var godot_default: Texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match mascara_num:
		1:
			sprite.texture = mascara_1_png
		2:
			sprite.texture = mascara_2_png
		3:
			sprite.texture = mascara_3_png
		4:
			sprite.texture = mascara_4_png
		_:
			sprite.texture = godot_default
	if GameState.completed_levels.get("level_"+str(mascara_num), false):
		sprite.show()
			
			
			

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
