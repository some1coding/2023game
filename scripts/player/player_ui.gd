extends CanvasLayer

@onready var health_text = $HealthRect/HealthText
@onready var ammo_text = $AmmoRect/AmmoText

@onready var health_rect = $HealthRect
@onready var ammo_rect = $AmmoRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ammo(item_data: ItemData) -> void:
	if item_data.slot_type == "Melee":
		ammo_rect.hide()
		return
	
	ammo_rect.show()
	
	ammo_text.text = str(item_data.current_clip_ammo) + "/" + str(item_data.current_extra_ammo)
