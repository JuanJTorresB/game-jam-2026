extends Node2D

@export var fragmento_numero :int
@export var area_2d :Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_recogida)
	pass

func _recogida(_body) -> void:
	print("Body Take Mascara")
	GameState.completed_levels["level_"+str(fragmento_numero)] = true
	print(GameState.completed_levels)
	
	queue_free()

func _process(_delta: float) -> void:
	pass
