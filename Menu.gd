extends Control

func _on_play_pressed():
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed():
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://scripts/utility/options_menu.tscn")

func _on_exit_pressed():
	pass # Replace with function body.
	get_tree().quit()
