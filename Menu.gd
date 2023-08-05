extends Control

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	print("ready ccalled")
	music.play()

func _on_play_pressed():
	music.stop()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
		# Stop the audio player before changing scenes
	

func _on_options_pressed():
	# Stop the audio player before changing scenes
	music.stop()
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")

func _on_exit_pressed():
	music.stop()
	get_tree().quit()
		# Stop the audio player before exiting the game

func _on_load_pressed():
	music.stop()
	get_tree().change_scene_to_file("res://scenes/ui/saves.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		#if event ==
		self.visible = false
		get_tree().paused = false


	
