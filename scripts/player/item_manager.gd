extends Node3D

var current_item_slot = "Primary"
var item_index: int = 1 # For switching items via scroll wheel, which requires a numeric key.
var is_changing_item: bool = true

@onready var all_items: Dictionary = {
	"ak_47":preload("res://scenes/items/ak_47.tscn")
}

# IMPORTANT: Make sure these are in the same order as update_item_index().
@onready var items: Dictionary = {
	"Melee":$Fists,
	"Primary":$AK47,
	"Secondary":null,
	"Grenade":null
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_item_index()

func set_item(item: String, slot: String = current_item_slot) -> void:
	request_action("drop_item", slot)
	items[slot] = call_deferred("add_child", all_items[item]) # Will create new slot entry if incorrect!
	
	print(items)

func get_item():
	pass

func request_action(item_action: String, slot: String = current_item_slot) -> void:
	if items[slot] != null:
		items[slot].request_action(item_action)
	else:
		print("No item currently equipped in slot " + slot)
	
	if item_action == "drop_item" and slot == current_item_slot:
		print(current_item_slot + str(item_index))
		next_item()


# There would be an infinite loop for these two if we had no items at all,
# which is why we must always have a 'fists' item in the melee slot at the least.
func next_item():
	item_index += 1
	
	if item_index >= items.size():
		item_index = 0
	
	if items[items.keys()[item_index]] == null:
		print("null")
		next_item()
	else:
		print("not null")
		request_action("unequip") # Unequip currently-held item.
		set_current_item(items.keys()[item_index])

func previous_item():
	item_index -= 1
	
	if item_index < 0:
		item_index = items.size() - 1
	
	if items[items.keys()[item_index]] == null:
		previous_item()
	else:
		request_action("unequip") # Unequip currently-held item.
		set_current_item(items.keys()[item_index])

func set_current_item(item_slot: String):
	print("current item set")
	current_item_slot = item_slot
	request_action("equip")
	print(current_item_slot + str(item_index))
	EventBus.update_player_ui.emit(items[current_item_slot].item_data)

# Scroll item change.
func update_item_index():
	match current_item_slot:
		"Melee":
			item_index = 0
		"Primary":
			item_index = 1
		"Secondary":
			item_index = 2
		"Grenade":
			item_index = 3
