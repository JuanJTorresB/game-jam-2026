extends Node2D

@export var secciones: Array[PackedScene]

var _seccion_actual: int = 0
var _nivel_instanciado: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_crear_nivel(_seccion_actual)

func _crear_nivel(numero_nivel: int):
	_nivel_instanciado = secciones[numero_nivel].instantiate()
	add_child(_nivel_instanciado)
	var hijos := _nivel_instanciado.get_children()
	for i in hijos:
		if i.is_in_group("personajes"):
			i.personaje_muerto.connect(_reiniciar_nivel	)
			break
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()
	
func _reiniciar_nivel():
	_eliminar_nivel()
	_crear_nivel.call_deferred(_seccion_actual)
	
func cambio_de_nivel(_entrando_a_seccion : int):
	_eliminar_nivel()
	_crear_nivel.call_deferred(_entrando_a_seccion)
