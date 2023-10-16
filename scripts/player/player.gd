extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D 

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var corolla: Corolla

var is_in_corolla: bool = false 
var is_fullscreen: bool = false

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

