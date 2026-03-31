extends Node2D

@onready var label: Label = $Winnings
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.warp_mouse(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2))
	label.text = str("You Won $", Global.Winnings, "!")
	Global.Money += Global.Winnings

func _process(_delta: float) -> void:
	if animation_player.current_animation == "loop?":
		if Input.is_action_just_pressed("punch") or Input.is_action_just_pressed("kick"):
			var next = str("res://scenes/main_menu.tscn")
			get_tree().change_scene_to_file.call_deferred(next)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_player.play("loop?")
