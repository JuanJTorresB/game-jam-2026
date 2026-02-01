extends Node2D
class_name LevelFade

@onready var animation_player: AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer
@export var next_level: Resource


func fade_out() -> void:
	animation_player.play("fade_out")

func finish_fade_out() -> void:
	get_tree().change_scene_to_packed(next_level)
