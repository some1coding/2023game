extends Control

@onready var saves_container: VBoxContainer = $MarginContainer/VBoxContainer/SavesContainer
@onready var lineedit: LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var warning: Label =  $MarginContainer/VBoxContainer/WarningContainer/Label
@onready var save_button_scene: PackedScene = load("res://scenes/ui/save_button.tscn")

# This is used to check if we try to make save with same name
var save_names: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Called whenever user presses enter 
func _on_line_edit_text_submitted(new_text: String):
	#if enter pressed without text it will print "empty" with text it will print "not empty"
	if not new_text.length() > 0: 
		warning.text = "WARNING: PLEASE WRITE A NAME FOR THE SAVE FILE!"
		return
	
	if new_text in save_names:
		warning.text = "WARNING: SAVE NAME ALREADY IN USE! "
		return
	#save_names["the"]
	
	#if save_names[str(new_text)] == true:
	#	warning.text = "WARNING: SAVE NAME ALREADY IN USE!"
	#	return
	
	var new_save_button: Button = save_button_scene.instantiate() 
	new_save_button.text = new_text
	new_save_button.pressed.connect(on_save_button_pressed.bind(new_text))
	#save_names[str(new_save_button.text)] = true
	save_names.append(new_text)
	
	saves_container.add_child(new_save_button)
	

func on_save_button_pressed(save_name: String) -> void:
	var real_save_name = save_name.strip_escapes().strip_edges()

	var file = FileAccess.open("user://current_save.txt", FileAccess.WRITE)
	#file.
	file.store_line(save_name)
	file.close()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
