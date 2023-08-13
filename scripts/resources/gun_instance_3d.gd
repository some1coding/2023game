extends ItemInstance3D
class_name GunInstance3D

# Effects.
@export var blood_impact: PackedScene
@export var dust_impact: PackedScene
@export var bullet_projectile: PackedScene

@export var muzzle: Node3D
@export var muzzle_flash: Node3D
@export var muzzle_flash_animation_player: AnimationPlayer
@export var animation_player: AnimationPlayer

# Audio.
@export var fire_sound: AudioStream
@export var reload_sound: AudioStream
@export var clip_load_sound: AudioStream

# These are sound effects that can be instantiated when a sound is played.
#var sound_3d = preload("res://scenes/audio/sound_3d.tscn")
#var sound_direct = preload("res://scenes/audio/sound_direct.tscn")

# This is an example of how to use them.
#var sound = sound_direct.instance()
#add_child(sound)
#sound.play_sound(audio_stream)

# Flags and stuff
var is_reloading: bool = false
var is_firing: bool = false


# Optional.
@export var equip_speed = 1.0
@export var unequip_speed = 1.0
@export var reload_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	pass # Replace with function body.

func unequip() -> void:
	is_equipped = false
	hide()
func equip() -> void:
	is_equipped = true
	show()

func request_action(item_action: String) -> void:
	match item_action:
		"fire":
			request_fire()
		"fire_2":
			request_aim()
		"fire_stop":
			request_fire_stop()
		"fire_2_stop":
			request_aim_stop()
		"drop_item":
			call_deferred("queue_free")
		"reload":
			reload()
		"equip":
			equip()
		"unequip":
			unequip()
		

func can_fire() -> bool:
	if is_reloading:
		return false
	if item_data.current_clip_ammo < 1:
		return false
	if is_firing:
		return false
	
	return true

func can_reload() -> bool:
	if item_data.current_clip_ammo >= item_data.max_clip_ammo:
		return false
	if item_data.current_extra_ammo <= 0:
		return false
	if is_reloading:
		return false
		
	return true

func _physics_process(delta: float) -> void:
	pass

func reload():
	if can_reload():
		is_firing = false
		is_reloading = true
		animation_player.play("reload")
	
# TODO: Better to do this as a method call in the animation track, so you can have different stages of reload completeness.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"reload":
			var ammo_needed = item_data.max_clip_ammo - item_data.current_clip_ammo
			if item_data.current_extra_ammo > ammo_needed:
				item_data.current_clip_ammo = item_data.max_clip_ammo
				item_data.current_extra_ammo -= ammo_needed
			else:
				item_data.current_clip_ammo += item_data.current_extra_ammo
				item_data.current_extra_ammo = 0

			
			is_reloading = false
			EventBus.update_player_ui.emit(item_data)
			
		"fire":
			is_firing = false
		
		


func request_fire_stop() -> void:
	is_firing = false

func request_fire() -> void:
	if !can_fire():
		return
	
	is_firing = true
	
	if item_data.is_automatic:
		animation_player.play("fire", -1.0, item_data.rate_of_fire)
	else:
		animation_player.play("fire", -1.0, item_data.rate_of_fire)

# Called from the animation track.
func fire_projectile() -> void:
	
	# This check here is for burst-fire weapons that call this function multiple
	# times on the same animation track. This makes sure the gun won't go into negative ammo.
	if item_data.current_clip_ammo < 1:
		return
	
	print("bang")
	
	item_data.current_clip_ammo -= 1
	
	if player_camera_ray == null:
		print("no player camera ray")
		#return
	
	# Spawn a raycast from the centre of the player camera.
	#player_camera_ray.force_raycast_update()
	
	var projectile_transform: Transform3D

	projectile_transform.basis = muzzle.global_transform.basis
	projectile_transform.origin = muzzle.global_transform.origin

	# This gets picked up by the projectile manager, which spawns a proectile.
	EventBus.projectile_fired.emit(item_data, projectile_transform)

func request_aim() -> void:
	print("aiming")
func request_aim_stop() -> void:
	print("not_aiming")
