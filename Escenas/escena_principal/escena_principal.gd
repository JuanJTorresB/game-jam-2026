extends Node2D

@export var secciones: Array[PackedScene]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
			i.get_child(0).personaje_muerto.connect(_reiniciar_nivel	)
			break
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()
	
func _reiniciar_nivel():
	print("Reiniciando el nivel")
	
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	_eliminar_nivel()
	_crear_nivel.call_deferred(_seccion_actual)
	
	animation_player.play("fade")
	
func cambio_de_nivel(_entrando_a_seccion : int):
	
	print("Cambio Nivel, Var: Entrando a Seccion: "+str(_entrando_a_seccion))
	
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	_seccion_actual = _entrando_a_seccion
	_eliminar_nivel()
	_crear_nivel.call_deferred(_entrando_a_seccion)
	
	animation_player.play("fade")
