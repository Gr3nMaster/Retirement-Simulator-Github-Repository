extends Node

const save_location = "user://RetirmentSimulatorSave.json"

var Money : int = 0
var WonLevels : Array
var Winnings : int
var MusicStart : float

var contents_to_save: Dictionary = {
	"money" : 0,
	"won_levels" : [],
	"music_volume" : 1.0,
	"max_fps" : 60
}

func _ready() -> void:
	_load()
	Money = contents_to_save.money
	WonLevels = contents_to_save.won_levels
	AudioServer.set_bus_volume_linear(0, contents_to_save.music_volume)
	Engine.max_fps = contents_to_save.max_fps

func _save():
	contents_to_save.money = Money
	contents_to_save.won_levels = WonLevels
	contents_to_save.music_volume = AudioServer.get_bus_volume_linear(0)
	contents_to_save.max_fps = Engine.max_fps
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.money = save_data.money
		contents_to_save.won_levels = save_data.won_levels
		contents_to_save.music_volume = save_data.music_volume
		contents_to_save.max_fps = save_data.max_fps
