extends Node2D

@export var secciones: Array[PackedScene]

var _seccion_actual: int = 1
var _nivel_instanciado: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _crear_nivel(numero_nivel: int):
	_nivel_instanciado = secciones[numero_nivel-1].instantiate()
	add_child(_nivel_instanciado)
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
