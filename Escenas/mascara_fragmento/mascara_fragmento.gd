extends Node2D

@export var fragmento_numero :int
@export var area_2d :Area2D
@export var sprite :Sprite2D
@export var animation :AnimationPlayer

@export var mascara_1_png: Texture
@export var mascara_2_png: Texture
@export var mascara_3_png: Texture
@export var mascara_4_png: Texture
@export var godot_default: Texture

const OUTRO_CUTSCENE = preload("uid://b3qlshbe44b7f")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_recogida)
	sprite.scale = Vector2(0.2, 0.2)
	animation.play("mascara_floating")
	match fragmento_numero:
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
	
	pass
func _recogida(_body) -> void:
	print("Body Take Mascara")
	GameState.completed_levels["level_"+str(fragmento_numero)] = true
	print(GameState.completed_levels)
	
	if GameState.completed_levels["level_1"] and GameState.completed_levels["level_2"] and GameState.completed_levels["level_3"] and GameState.completed_levels["level_4"]:
		get_tree().change_scene_to_packed(OUTRO_CUTSCENE)
	
	queue_free()

func _process(_delta: float) -> void:
	pass
