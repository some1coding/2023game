extends CharacterBody3D

@onready var head = $Head
@onready var ground_check = $GroundCheck
@onready var pause_menu = $Head/Camera3D/Menu

var speed = 10
var h_accelaration = 6
var air_acceleration = 1 
var normal_acceleration = 6
var gravity = 20
var jump = 10 
var full_contact = false

var mouse_sensitivity = 0.05

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event == "pause_menu":
		print("notongfrfrau")
	print(event)
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

		
		

func _physics_process(delta):
	
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true 
	else:
		full_contact = false  
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_accelaration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_accelaration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_accelaration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump 
	
	if Input.is_action_pressed("move_forwards"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction+= transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction+= transform.basis.x
		
	direction = direction.normalized()	
	h_velocity = h_velocity.lerp(direction * speed, h_accelaration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	set_velocity(movement)

	move_and_slide()
	
	#if Input.is_action_pressed("ui_cancel"):
		#print("ranga")
		#pause_menu.show()	
