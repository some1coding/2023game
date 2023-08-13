extends Control

@onready var saves_container: VBoxContainer = $MarginContainer/VBoxContainer/SavesContainer
@onready var lineedit: LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var warning: Label =  $MarginContainer/VBoxContainer/WarningContainer/Label
@onready var save_button_scene: PackedScene = load("res://scenes/ui/save_button.tscn")

# This is used to check if we try to make save with same name
var save_names: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_save_buttons()
	


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
	
	add_button(new_text)
	
func add_button(button_name: String):
	var new_save_button: Button = save_button_scene.instantiate() 
	new_save_button.text = button_name
	new_save_button.pressed.connect(on_save_button_pressed.bind(button_name))
	#save_names[str(new_save_button.text)] = true
	save_names.append(button_name)
	
	saves_container.add_child(new_save_button)
	
	
func load_save_buttons():
	var save_directory = DirAccess.open("user://saves")
	var saves: PackedStringArray = save_directory.get_files()
	for save_file in saves: 
		if save_file.get_extension() != "txt":
			continue #skips the save and moves on to the next one 
		var slice_count = save_file.get_slice_count(".")
		var slices : PackedStringArray 
		for i in range (slice_count-1): #remove last_slice which is the file extension so we can get the actual name of the save file
			var slice = save_file.get_slice(".",i)
			slices.append(slice)
		#Adds all the slices back together with all of the fullstops exept for the file extension
		var actual_save_file_name = ".".join(slices)
		add_button(actual_save_file_name)
			
func on_save_button_pressed(save_name: String) -> void:
	var real_save_name = save_name.strip_escapes().strip_edges()

	var file = FileAccess.open("user://current_save.txt", FileAccess.WRITE)
	#file.
	file.store_line(save_name)
	file.close()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
