extends CharacterBody2D
class_name PlayerScript

signal personaje_muerto

@onready var ray_left   : RayCast2D = $RayLeft
@onready var ray_right  : RayCast2D = $RayRight
@onready var ray_center  : RayCast2D = $RayCenter
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var material_presonaje_rojo: ShaderMaterial
@export var animacion: Node
@export var area_2d : Area2D
@export var can_dash : bool
@export var spotlight: ColorRect

var _muerto: bool = false

const TILE_SIZE = 64
const SPEED_TILES = 6
const JUMP_HEIGHT_TILES = 5
const JUMP_TIME = 0.5

const COYOTE_TIME = 0.13
var coyote_timer = 0.0

const FALL_MULTIPLIER = 2.2
const JUMP_CUT_MULTIPLIER = 0.7

const SPEED = SPEED_TILES * TILE_SIZE
const JUMP_HEIGHT = JUMP_HEIGHT_TILES * TILE_SIZE

const GRAVITY = (2.0 * JUMP_HEIGHT) / pow(JUMP_TIME, 2)
const JUMP_VELOCITY = -GRAVITY * JUMP_TIME

const JUMP_BUFFER = 0.20
var jump_buffer_timer = 0.0

const CORRECTION_JUMP = 15

const DASH_SPEED = 14 * TILE_SIZE
const DASH_TIME = 0.15
const DASH_COOLDOWN = 0.5

const INPUTLESS_SLINGSHOT_WINDOW := 0.5

var inputless_slingshot_time: float = 0
var h_vel := 0.0

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown = 0.0
var dash_direction = 1
var jumping := false

@onready var respawn_point := global_position

func _ready() -> void:
	add_to_group("personajes")
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):	
	
	if _muerto:
		return
	
	# Definir direccion del personaje
	var direction = Input.get_axis("left", "right")	
	if direction != 0:
		player_sprite.flip_h = direction < 0
	
	# Actualizar coyote time
	if is_on_floor():
		coyote_timer = COYOTE_TIME		
		h_vel *= 0.8
		inputless_slingshot_time = 0
		jumping = false

	# Gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		coyote_timer -= delta
		if velocity.y > 0:
			velocity.y += GRAVITY * (FALL_MULTIPLIER - 1) * delta

	# Salto (con coyote time)
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER
		jumping = true

	jump_buffer_timer -= delta
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	if Input.is_action_just_pressed("dash"):
		print_debug("dash")
		start_dash()
		
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0	

	if is_dashing:
		dash_timer -= delta

		# Mantener velocidad constante
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

		if dash_timer <= 0:
			is_dashing = false

	if dash_cooldown > 0:
		dash_cooldown -= delta
	
	
	if not is_dashing:
		if inputless_slingshot_time > 0 :
			velocity.x = h_vel
		else: 
			velocity.x = direction * SPEED + h_vel

	if inputless_slingshot_time > 0 :
		inputless_slingshot_time -= delta
	else:
		h_vel = sign(h_vel) * max(0, abs(h_vel - direction))

	#Animacion del personaje
	if is_dashing:
		player_sprite.play("dash")
	elif jumping:
		player_sprite.play("jump")
	elif direction != 0 :
		player_sprite.play("walk")
	else:
		player_sprite.play("idle")
	

	apply_edge_correction()
	move_and_slide()
	
	if spotlight != null:
		
		var shader: ShaderMaterial = spotlight.material
		var viewport_size = camera_2d.get_viewport_rect().size
		var spotlight_pos = ((global_position - camera_2d.global_position) / viewport_size) + Vector2(0.5, 0.5)
		
		var spotlight_scale = viewport_size.normalized()
		spotlight_scale = spotlight_scale / min(spotlight_scale.x, spotlight_scale.y)
		
		shader.set_shader_parameter("spotlight_x", spotlight_pos.x)
		shader.set_shader_parameter("spotlight_y", spotlight_pos.y)
		shader.set_shader_parameter("spotlight_w", spotlight_scale.y)
		shader.set_shader_parameter("spotlight_h", spotlight_scale.x)

func apply_edge_correction():
	# Solo mientras sube
	if velocity.y > 0:
		return

	if(not ray_right.is_colliding() and not  ray_center.is_colliding()  and ray_left.is_colliding()):
		position.x += CORRECTION_JUMP;
	
	if(not ray_left.is_colliding()  and not  ray_center.is_colliding() and  ray_right.is_colliding()):
		position.x -= CORRECTION_JUMP;
		return
		
func start_dash():
	if !can_dash or is_dashing or dash_cooldown > 0:
		return

	is_dashing = true
	dash_timer = DASH_TIME
	dash_cooldown = DASH_COOLDOWN

	dash_direction = get_dash_direction()

	velocity.y = 0
	velocity.x = dash_direction * DASH_SPEED
	

		
func get_dash_direction():
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		return sign(dir)
	return -1 if player_sprite.flip_h else 1 #sign(velocity.x) if velocity.x != 0 else 1
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	animacion.material = material_presonaje_rojo 
	_muerto = true
	player_sprite.stop()
	await get_tree().create_timer(0.5).timeout
	personaje_muerto.emit()
	
