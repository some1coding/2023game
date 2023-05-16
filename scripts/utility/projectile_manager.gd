extends Node3D

# Pool of projectiles, these are added and deleted when a gun is fired.
var projectiles: Array = []
# So we can get the correct last position for each bullet.
var projectile_index = 0
# So that the projectile isn't clipping with the gun when spawned.
var projectile_offset = 3.5
# Same as with the projectile pool.
var impact_effects = []

@export var projectile_data: ProjectileData = null

@onready var dust_impact: PackedScene = preload("res://scenes/effects/dust_impact.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.projectile_fired.connect(_on_projectile_fired)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	process_projectiles(delta)

func _on_projectile_fired(item_data: ItemData, projectile_transform: Transform3D):
	var new_projectile = instantiate_node(item_data.projectile_scene, projectile_transform)
	new_projectile.transform = projectile_transform
	new_projectile.is_active = true
	new_projectile.speed = item_data.projectile_speed
	new_projectile.damage = item_data.damage
	
	projectiles.append(new_projectile)

func process_projectiles(delta):
	for bullet in projectiles:
		# Get the last position of the bullet, from which we can draw the ray.
		bullet.last_position = bullet.transform.origin

		# Delete bullet if it's existed for too long.
		bullet.lifetime -= delta
		if bullet.lifetime < 0:
			# Delete the bullet and remove it from the array.
			bullet.queue_free()
			projectiles.erase(bullet)
		
		bullet.transform.origin = bullet.transform.origin + (-bullet.transform.basis.z * bullet.speed)
		var space_state = get_world_3d().direct_space_state
		var ray_parameters := PhysicsRayQueryParameters3D.create(
				bullet.last_position,
				bullet.transform.origin,) #TODO: collision mask, self

		var collision = space_state.intersect_ray(ray_parameters)
		if collision:
			var impact
			# Spawn the hit effect a little bit away from the surface to reduce clipping.
			var impact_position = (collision.position) + (collision.normal * 0.2)
			var hit = collision.collider

			# Check if we hit an enemy, then damage them. Spawn the correct impact effect.
			if hit.is_in_group("Enemy"):
				hit.damage(bullet.damage)
				print("hit enemy")
				#var new_impact = instantiate_node(blood_impact, impact_position)
				#new_impact.position = impact_position

				#impact_effects.append(new_impact)
			else:
				print("hit not enemy")
				#var impact_transform = Transform3D(collision.normal, collision.position)
				var impact_transform = Transform3D(Basis(), collision.position)
				
				var new_impact: GPUParticles3D = instantiate_node(dust_impact, impact_transform)
				new_impact.emitting = true

				impact_effects.append(new_impact)
			# Delete the bullet and remove it from the array.
			bullet.queue_free()
			projectiles.erase(bullet)

func instantiate_node(packed_scene: PackedScene, p_transform: Transform3D) -> Node3D:
	var clone = packed_scene.instantiate()
	add_child(clone)
	clone.global_transform.origin = p_transform.origin
	
	return clone
	
