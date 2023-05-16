extends ItemData
class_name GunData

@export_group("Gun Properties")

@export var is_automatic: bool = false

@export var max_extra_ammo: int = 120
@export var current_extra_ammo: int = 120
@export var max_clip_ammo: int = 30
@export var current_clip_ammo: int = 30

@export var damage = 15
@export var rate_of_fire: float = 1.0 # Non-automatic weapons also consider this.
@export var projectiles_per_shot = 5
@export var projectile_speed = 4.0
@export var randomness = 0.5
@export var raycast_distance = 5 # Distance beyond which we generate projectiles when fired.

@export var projectile_scene: PackedScene
