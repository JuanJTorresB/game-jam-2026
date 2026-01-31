extends Node2D

@onready var player_sprite: Sprite2D = $CharacterBody2D/Sprite2D
@onready var player: CharacterBody2D = $CharacterBody2D
const ICON = preload("uid://c5rwpacstwx7p")
var player_image : Image

var snapshots: Array[Vector2] = []
var prev_rewind_pos: Vector2
var can_slingshot: bool = false
var rewind_velocity: float = 0

var buffer_size = 60

func _draw() -> void:
	
	var atlas: AtlasTexture = player_sprite.texture
	
	var full_image = player_sprite.texture.get_image()
	var region_image = full_image.get_region(player_sprite.region_rect)
	var new_texture = ImageTexture.create_from_image(region_image)

	var tex = new_texture
	#player_sprite.texture.draw_rect_region(CanvasItem.get)
	
	for i in range(snapshots.size() / 10) :
		var snapshot = snapshots[i * 10]
		
		draw_texture(tex, snapshot, Color(1, 1, 1, 0.5))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	queue_redraw()
	
	if Input.is_action_just_pressed("rewind") :
		rewind_velocity = player.velocity.length()
	if !snapshots.is_empty() and Input.is_action_pressed("rewind") :
		prev_rewind_pos = player.position
		can_slingshot = true
		player.position = snapshots.pop_back()
	elif Input.is_action_just_released("rewind") and can_slingshot :
		player.velocity = (player.position - prev_rewind_pos).normalized() * rewind_velocity
		can_slingshot = false
	else:
		snapshots.push_back(player.position)
		if snapshots.size() > buffer_size :
			snapshots.pop_front()
