extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var start: Button = $"Main Page/start"
@onready var reset: Button = $"Main Page/reset"
@onready var options: Button = $"Main Page/options"
@onready var quit: Button = $"Main Page/quit"
@onready var main_slider: HSlider = $"Options/MarginContainer/VBoxContainer/Main vol/HSlider"
@onready var money: Label = $"Main Page/Money"
@onready var fps: SpinBox = $Options/MarginContainer/VBoxContainer/FPS/HSlider
@onready var final_victory: Button = $"Main Page/final_victory"

var resolutions : Array = [
	Vector2(1024, 576),
	Vector2(854, 480),
	Vector2(1920, 1080),
	Vector2(1600, 900),
	Vector2(1280, 720)
]

func _ready() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	money.text = str("$", Global.Money, " / $2000000")
	if Global.Money == 2000000:
		final_victory.visible = true
	else:
		final_victory.visible = false

#what occurs when you press the start button, and everything down that path
func _on_start_button_up() -> void:
	start.disabled = true
	reset.disabled = true
	options.disabled = true
	quit.disabled = true
	reset.text = "Reset"
	animation.play("start_open")

func _on_tutorial_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial/test_level.tscn")

func _on_level_1_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level 1/phase 1.tscn")

func _on_level_2_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level 2/phase 1.tscn")

func _on_level_3_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level 3/phase 1.tscn")

func _on_level_4_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level 4/phase 1.tscn")

func _on_level_5_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/level 5/phase 1.tscn")

func _on_back_button_up() -> void:
	animation.play("start_close")

#reset button
func _on_reset_button_up() -> void:
	if reset.text == "Reset":
		reset.text = "ARE YOU SURE? (All money will be lost)"
	elif reset.text == "ARE YOU SURE? (All money will be lost)":
		Global.Money = 0
		Global.WonLevels.clear()
		reset.text = "Reset"
		_ready()

#all buttons after the options button
func _on_options_button_up() -> void:
	main_slider.value = AudioServer.get_bus_volume_linear(0)
	fps.value = Engine.max_fps
	start.disabled = true
	reset.disabled = true
	options.disabled = true
	quit.disabled = true
	reset.text = "Reset"
	animation.play("options_open")

func _on_confirm_button_up() -> void:
	AudioServer.set_bus_volume_linear(0, main_slider.value)
	Engine.max_fps = int(fps.value)
	animation.play("options_close")

func _on_cancel_button_up() -> void:
	animation.play("options_close")

#animations finished 
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"options_close", "start_close":
			start.disabled = false
			reset.disabled = false
			options.disabled = false
			quit.disabled = false

#just the quit button lol
func _on_quit_button_up() -> void:
	Global._save()
	get_tree().quit()

#see retire screen
func _on_final_victory_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/final_victory.tscn")
