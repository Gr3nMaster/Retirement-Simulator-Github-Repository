extends Node2D

@onready var enemies: Node2D = $enemies
@onready var player: CharacterBody2D = $Player
@onready var health: TextureProgressBar = $Health
@onready var begin_music: AudioStreamPlayer2D = $"Fight Begin"
@onready var fight_music: AudioStreamPlayer2D = $"Fight Music"
@onready var win_music: AudioStreamPlayer2D = $"Fight Win"
@onready var timer: Timer = $Timer
@onready var pause_menu: Control = $"Pause Menu"

var enemy_count : int
@export var next_scene : String
@export var winnings : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	enemy_count = enemies.get_child_count()
	if not begin_music:
		fight_music.play(Global.MusicStart)

# keeps track of the player's health
func _process(_delta: float) -> void:
	health.value = player.HP
	if Input.is_action_just_pressed("pause"):
		pause()

#registers when an enemy dies
func oh_no_i_died_bleh() -> void:
	enemy_count -= 1
	if enemy_count == 0:
		if not win_music:
			timer.start()
		else:
			player.play = false
			player.animation.play("victory")
			fight_music.stop()
			win_music.play()

# starts the movement once the round begins
func on_start() -> void:
	for n in enemy_count:
		enemies.get_children()[n].play = true
	player.play = true
	if begin_music:
		fight_music.play()

func _on_fight_win_finished() -> void:
	Global.MusicStart = fight_music.get_playback_position()
	if winnings:
		if self.name not in Global.WonLevels:
			Global.Winnings = winnings
			Global.WonLevels.append(self.name)
			get_tree().change_scene_to_file.call_deferred("res://scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file.call_deferred(next_scene)
	else:
		get_tree().change_scene_to_file.call_deferred(next_scene)

func pause() -> void:
	if get_tree().paused == true:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		pause_menu.visible = false
		get_tree().paused = false
	elif get_tree().paused == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_menu.visible = true
		get_tree().paused = true
