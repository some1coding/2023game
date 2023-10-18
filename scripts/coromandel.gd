extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_game():
	var file_that_contains_save_name = FileAccess.open("user://current_save.txt", FileAccess.READ)
	var name_of_current_save_file = file_that_contains_save_name.get_as_text()
	
	# the get_as_text function adds an enter character to the end of the string
	# we will get an error if we try to access a directory with an enter key
	name_of_current_save_file = name_of_current_save_file.strip_edges()
	
	var save_file_path = "user://saves/" + str(name_of_current_save_file) + ".txt"
	if not FileAccess.file_exists(save_file_path):
		return
		
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if save_file.get_length()<1:
		return
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		#Creates the helper class to interact with JSON
		var json = JSON.new() 
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		var node = get_node(node_data["node_path"]) 
		print(node)
		node.load(node_data)
