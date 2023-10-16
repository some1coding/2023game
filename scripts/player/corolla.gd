extends VehicleBody3D

class_name Corolla
const MAX_STEER: float = 0.8
const ENGINE_POWER = 300 

@onready var camera_pivot = $CameraPivot
@onready var forward_camera = $CameraPivot/ForwardCamera
@onready var reverse_camera = $CameraPivot/ReverseCamera
@onready var look_at = global_position

var is_player_in_corolla: bool = false

var movement_direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_player_in_corolla:
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	steering = move_toward(steering, movement_direction.x * MAX_STEER, delta * 2.5)
	engine_force = movement_direction.y * ENGINE_POWER
	movement_direction = Vector2(0, 0)
	if not is_player_in_corolla:
		return
	movement_direction.x = Input.get_axis("move_right", "move_left")
	movement_direction.y = Input.get_axis("move_backwards", "move_forwards")
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	forward_camera.look_at(look_at)
	reverse_camera.look_at(look_at)
	_check_camera_switch()
	
	
func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) < 0.1:
		forward_camera.current = true
	else:
		reverse_camera.current = true 
