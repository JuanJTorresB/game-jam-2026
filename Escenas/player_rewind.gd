extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var player_sprite: Sprite2D = $CharacterBody2D/Sprite2D

var snapshots: Array = []
var buffer_size := 60

var prev_rewind_pos: Vector2
var can_slingshot := false
var rewind_velocity := 0.0


func _physics_process(_delta: float) -> void:
	queue_redraw()

	# Inicio del rewind
	if Input.is_action_just_pressed("rewind"):
		rewind_velocity = player.velocity.length()

	# Mientras se mantiene rewind
	if !snapshots.is_empty() and Input.is_action_pressed("rewind"):
		var snap = snapshots.pop_back()

		prev_rewind_pos = player.position
		can_slingshot = true

		player.position = snap.pos
		player_sprite.frame = snap.frame
		player_sprite.flip_h = snap.flip_h

	# Al soltar rewind → slingshot
	elif Input.is_action_just_released("rewind") and can_slingshot:
		player.velocity = (player.position - prev_rewind_pos).normalized() * rewind_velocity
		can_slingshot = false

	# Grabación normal
	else:
		snapshots.push_back({
			"pos": player.position,
			"frame": player_sprite.frame,
			"flip_h": player_sprite.flip_h
		})

		if snapshots.size() > buffer_size:
			snapshots.pop_front()


func _draw() -> void:
	if snapshots.is_empty():
		return

	var tex: Texture2D = player_sprite.texture
	var scale := player_sprite.global_scale

	for i in range(snapshots.size() / 10):
		var snap = snapshots[i * 10]
		var frame_rect = get_frame_rect_from_frame(snap.frame)

		var size = frame_rect.size * scale
		var pos = snap.pos - size * 0.5

		draw_texture_rect_region(
			tex,
			Rect2(pos, size),
			frame_rect,
			Color(4.666, 18.892, 18.892, 0.4)
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
