extends Node2D
class_name ExtendablePlatform

@export var extension_texture: Texture2D
@export var time_extended: float = 1.5
@export var target_length: float = 300
@export var extend_speed: float = 2
@export var inverted: bool = false
@export var is_flora: bool = false

@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@onready var anchor: Vector2 = Vector2(position)
@onready var grow_progress: float = 1 if inverted else 0

var grown_time_left: float = 0
var grown_length: float = 0
var stalk_segments: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_position()
	pass # Replace with function body.

func _draw() -> void:
	for i in range(stalk_segments):
		draw_texture(extension_texture,  Vector2(0, i * extension_texture.get_height()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_flora and Input.is_action_just_pressed("grow_flora") :
		extend()
	if time_extended > 0:
		grown_time_left -= delta
	grow_progress = clamp(grow_progress + (extend_speed * (delta if grown_time_left > 0 != inverted else -delta)), 0, 1)
	grown_length = lerp(0.0, target_length, grow_progress)
	update_position()
	
func update_position() -> void:
	
	var stalk_tex_height = extension_texture.get_height()
	
	var sl = ceili(grown_length / stalk_tex_height)
	position = anchor + (Vector2(sin(rotation), -cos(rotation)) * grown_length)
	
	if sl != stalk_segments :
		stalk_segments = sl
		queue_redraw()
		
		collision_shape_2d.scale.y = stalk_segments + 1
		collision_shape_2d.position.y = (stalk_segments * stalk_tex_height) * 0.5
		if inverted:
			collision_shape_2d.position.y -= target_length
	

func extend() -> void:
	grown_time_left = 0 if grown_time_left > 0 else time_extended if time_extended >= 0 else 1
