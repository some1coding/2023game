extends Resource
class_name ItemData

@export_group("Item Properties")
@export var item_name: String = "Default"
@export var can_be_dropped: bool = true
@export_enum("Any", "Melee", "Primary", "Secondary", "Grenade") var slot_type: String = "any"

var is_equipped: bool = false
