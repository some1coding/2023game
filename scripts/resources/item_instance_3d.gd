extends Node3D
class_name ItemInstance3D

var player_camera_ray: RayCast3D

@export var item_data: ItemData
# Rigidbody version for picking up/dropping.
@export var item_pickup: PackedScene
var is_equipped: bool = false

func _ready() -> void:
	unequip()

func unequip() -> void:
	is_equipped = false
	hide()
func equip() -> void:
	is_equipped = true
	show()

func request_action(item_action: String) -> void:
	match item_action:
		"drop_item":
			if item_data.can_be_dropped:
				call_deferred("queue_free")
		"equip":
			equip()
		"unequip":
			unequip()
			
