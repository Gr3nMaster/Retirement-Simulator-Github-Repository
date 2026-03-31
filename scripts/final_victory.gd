extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade in")
	Input.warp_mouse(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2))
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("punch") or Input.is_action_just_pressed("kick"):
		var next = str("res://scenes/main_menu.tscn")
		get_tree().change_scene_to_file.call_deferred(next)
