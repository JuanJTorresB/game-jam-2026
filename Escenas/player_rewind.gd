extends Node2D

@onready var player_body: CharacterBody2D = $CharacterBody2D
@onready var player_script: PlayerScript = $CharacterBody2D
@onready var player_sprite: Sprite2D = $CharacterBody2D/Sprite2D

@export var enabled := true
@export var buffer_size := 120
@export var afterimage_interval := 5
@export var afterimage_color := Color(4.666, 18.892, 18.892, 0.4)
@export var max_slingshot_vel = 1500

var snapshots: Array = []

var prev_rewind_pos: Vector2
var can_slingshot := false
var rewind_velocity := 0.0


func _physics_process(_delta: float) -> void:

	if !enabled :
		return

	# Inicio del rewind
	if Input.is_action_just_pressed("rewind"):
		rewind_velocity = player_body.velocity.length()

	# Mientras se mantiene rewind
	if !snapshots.is_empty() and Input.is_action_pressed("rewind"):
		var snap = snapshots.pop_back()

		prev_rewind_pos = player_body.position
		can_slingshot = true

		player_body.position = snap.pos
		player_sprite.frame = snap.frame
		player_sprite.flip_h = snap.flip_h
		queue_redraw()

	# Al soltar rewind → slingshot
	elif Input.is_action_just_released("rewind") and can_slingshot:
		
		var vel = sign(rewind_velocity) * min(abs(rewind_velocity), max_slingshot_vel)
		player_body.velocity = (player_body.position - prev_rewind_pos).normalized() * vel
		can_slingshot = false
		player_script.h_vel = player_body.velocity.x
		player_script.inputless_slingshot_time = player_script.INPUTLESS_SLINGSHOT_WINDOW
		queue_redraw()

	# Grabación normal
	elif !Input.is_action_pressed("rewind") and (snapshots.is_empty() or !player_body.position.is_equal_approx(snapshots.get(snapshots.size()-1).pos)):
		snapshots.push_back({
			"pos": player_body.position,
			"frame": player_sprite.frame,
			"flip_h": player_sprite.flip_h
		})

		if snapshots.size() > buffer_size:
			snapshots.pop_front()


func _draw() -> void:
	if !enabled or snapshots.is_empty() or !Input.is_action_pressed("rewind") or Input.is_action_just_released("rewind"):
		return

	var tex: Texture2D = player_sprite.texture
	var scale := player_sprite.global_scale

	for i in range(snapshots.size() / afterimage_interval):
		var snap = snapshots[i * afterimage_interval]
		var frame_rect = get_frame_rect_from_frame(snap.frame)

		var size = frame_rect.size * scale
		var pos = snap.pos - size * 0.5

		draw_texture_rect_region(
			tex,
			Rect2(pos, size),
			frame_rect,
			afterimage_color
		)

func get_frame_rect_from_frame(frame: int) -> Rect2:
	var frame_w = player_sprite.texture.get_width() / player_sprite.hframes
	var frame_h = player_sprite.texture.get_height() / player_sprite.vframes

	var col = frame % player_sprite.hframes
	var row = frame / player_sprite.hframes

	return Rect2(
		Vector2(col * frame_w, row * frame_h),
		Vector2(frame_w, frame_h)
	)
