extends Node3D

@onready var ligths_of_globe: Node3D = $Pivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		# Rotate the lights_of_globe node around the X-axis
		ligths_of_globe.rotation_degrees.x += 90 * delta  # Rotate 90 degrees per second
