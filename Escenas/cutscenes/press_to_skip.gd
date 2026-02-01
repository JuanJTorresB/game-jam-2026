extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var skip_cutscene_label: Label = $SkipCutsceneLabel
@onready var level_fade: LevelFade = $CanvasLayer/LevelFade

var skips := 2
var pressed := false
var done_playing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if !animation_player.is_playing() and !done_playing:
		done_playing = true
		skips -= 1
	
	if Input.is_anything_pressed():
		if !pressed:
			skips -= 1
		pressed = true
	else: 
		pressed = false
	
	if skips <= 1:
		skip_cutscene_label.show()
	if skips == 0:
		level_fade.fade_out()
		skips -= 1
	
	pass
