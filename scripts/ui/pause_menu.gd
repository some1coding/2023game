extends Control

func _on_exit_pressed():
	get_tree().quit()
		# Stop the audio player before exiting the game

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = not visible
		
		
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
