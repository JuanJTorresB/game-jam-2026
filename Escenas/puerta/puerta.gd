extends Node2D

@export var area2d: Area2D
@export var nivel_destino: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d.body_entered.connect(_puerta_usada)
	if GameState.completed_levels.get("level_"+str(nivel_destino), false):
		self.queue_free()

func _puerta_usada(_body):
	print("Cuerpo entrando a la puerta: " + str(nivel_destino))
	print(get_parent().get_parent().get_parent().name)
	get_parent().get_parent().get_parent().cambio_de_nivel(nivel_destino)
	match nivel_destino:
		1:
			_body.can_dash = false
			_body.get_parent().enabled = false
		2:
			_body.can_dash = true
		3:
			pass
		4:
			pass
		5:
			pass
		_:
			pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
