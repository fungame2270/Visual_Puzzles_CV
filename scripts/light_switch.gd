extends StaticBody3D

@export var light : SpotLight3D

func interact(caller):
	if light.visible:
		light.visible = false
	else:
		light.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass