extends StaticBody3D

@onready var camera_3d: Camera3D = $"../OutsideViewport/Camera3D"
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var blockbench_export: Node3D = $blockbench_export

var current_rotation = 0
var camera_distance = 13.0  # Distance from the object to the camera
var player_distance = 1.0
var rotation_speed = 0.005  # Speed of rotation
var locked = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Initialize anything if necessary.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotation.y -= rotation_speed
		blockbench_export.rotation.y += rotation_speed
	elif Input.is_action_pressed("ui_right"):
		rotation.y += rotation_speed
		blockbench_export.rotation.y -= rotation_speed
	elif Input.is_action_just_pressed("interact"):
		if not locked:
			locked = true
		else:
			locked = false

	# Update the camera position to orbit around the object
	update_camera_position()
	if locked:
		update_player_position()

# Update camera position to orbit around the object
func update_camera_position() -> void:
	# Calculate the new position of the camera based on the object's rotation
	var angle = rotation.y  # The angle of the object around the Y-axis
	var offset = Vector3(-sin(angle) * camera_distance, 2, -cos(angle) * camera_distance)
	
	# Position the camera in the correct spot based on the angle
	camera_3d.position = global_transform.origin + offset
	camera_3d.look_at(Vector3(global_transform.origin.x, 1, global_transform.origin.z), Vector3.UP)

func update_player_position() -> void:
	# Calculate the new position of the camera based on the object's rotation
	var angle = rotation.y  # The angle of the object around the Y-axis
	var offset = Vector3(-sin(angle) * player_distance, 0, -cos(angle) * player_distance)
	
	# Position the camera in the correct spot based on the angle
	character_body_3d.position = global_transform.origin + offset
	character_body_3d.look_at(global_transform.origin, Vector3.UP)
