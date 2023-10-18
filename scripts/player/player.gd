extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D 

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var corolla: Corolla

var is_in_corolla: bool = false 
var is_fullscreen: bool = false

# Saving, this value is read from the 'current_save.txt' file.
var name_of_current_save_file: String = ""


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if is_in_corolla:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.01)  
		camera.rotate_x(-event.relative.y * 0.01)
		camera.rotation.x = clamp(camera.rotation.x, -90 * (PI/180), 90 * (PI/180))
	if event.is_action_pressed("save"):
		var file_that_contains_save_name = FileAccess.open("user://current_save.txt", FileAccess.READ)
		name_of_current_save_file = file_that_contains_save_name.get_as_text()
		
		# the get_as_text function adds an enter character to the end of the string
		# we will get an error if we try to access a directory with an enter key
		name_of_current_save_file = name_of_current_save_file.strip_edges()
		
		
		DirAccess.open("user://").make_dir("saves")
		var save_file = FileAccess.open("user://saves/" + str(name_of_current_save_file) + ".txt", FileAccess.WRITE)
		
		# Now, we can call our save function on each node.
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		print(save_nodes)
		for node in save_nodes:
			var save_data: Dictionary = node.save()
			var json_string = JSON.stringify(save_data)
			save_file.store_line(json_string)
			print(save_data)
		
func _physics_process(delta):
	if Input.is_action_just_pressed("fire"):
		is_in_corolla = not is_in_corolla
		corolla.is_player_in_corolla = is_in_corolla
		if is_in_corolla:
			corolla.forward_camera.current = true
		else:
			camera.current = true
	if is_in_corolla:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta	 

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("toggle_fullscreen"):
		is_fullscreen = not is_fullscreen 
		if is_fullscreen: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func save() -> Dictionary:
	var save_dict = {
		"node_path" : get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z,
		"rot_y" : rotation.y,
		"camera_rot_x" : camera.rotation.x,
	}
	return save_dict

func load(data: Dictionary):
	position.x = data["pos_x"]
	position.y = data["pos_y"]
	position.z = data["pos_z"]
	rotation.y = data["rot_y"]
	camera.rotation.x = data["camera_rot_x"]
