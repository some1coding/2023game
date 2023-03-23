extends RayCast3D

var prompt

func _ready():
	prompt = $Prompt
	add_exception(owner)

func _physics_process(delta):
	prompt.text = ""
	if is_colliding():
		prompt.text = "Hmmm... that is something."

