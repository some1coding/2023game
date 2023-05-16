extends RigidBody3D
class_name ItemPickup3D

@export var item_data: ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_item_pickup_data() -> ItemData:
	return item_data

func _on_sleeping_state_changed() -> void:
	pass # Replace with function body.
