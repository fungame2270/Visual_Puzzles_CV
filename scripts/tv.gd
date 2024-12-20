extends StaticBody3D

@onready var camera_3d: Camera3D = $"../OutsideCameraViewport/Camera3D"
@onready var player: CharacterBody3D = $"../Player"
@onready var blockbench_export: Node3D = $blockbench_export
@onready var center: Node3D = $center

var current_rotation = 0
var camera_distance = 5.0  # Distance from the object to the camera
var player_distance = 1.0
var rotation_speed = 0.01  # Speed of rotation
var locked = false

var frustum_max
var frustum_min
var camera_scroll_speed = 0.5

var scroll_mode = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frustum_max = camera_3d.far
	frustum_min = camera_3d.near

func interact(caller):
	if not locked:
		locked = true
	else:
		locked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if locked:
		if Input.is_action_pressed("move_left"):
			rotation.y -= rotation_speed
			blockbench_export.rotation.y += rotation_speed
		elif Input.is_action_pressed("move_right"):
			rotation.y += rotation_speed
			blockbench_export.rotation.y -= rotation_speed
			
	#if Input.is_action_just_pressed("interact"):
		#if not locked:
			#locked = true
		#else:
			#locked = false

	if locked:
		if Input.is_action_just_released("extra_1"):
			if camera_3d.projection == Camera3D.PROJECTION_PERSPECTIVE:
				camera_3d.projection = Camera3D.PROJECTION_ORTHOGONAL
				camera_3d.size = 4
			else:
				camera_3d.projection = Camera3D.PROJECTION_PERSPECTIVE
				camera_3d.size = 1
		
		# 1.5 -> 7
		if Input.is_action_pressed("extra_2"):
			scroll_mode = "near"

		if Input.is_action_pressed("extra_3"):
			scroll_mode = "far"

		if Input.is_action_just_released("MWU"): 
			var next_position = camera_3d.near + camera_scroll_speed
			if scroll_mode == "near" and next_position <= frustum_max and next_position < camera_3d.far:
				camera_3d.near += camera_scroll_speed
			
			next_position = camera_3d.far + camera_scroll_speed
			if scroll_mode == "far" and next_position <= frustum_max:
				camera_3d.far += camera_scroll_speed
		
		if Input.is_action_just_released("MWD"): 
			var next_position = camera_3d.near - camera_scroll_speed
			if scroll_mode == "near" and next_position >= frustum_min:
				camera_3d.near -= camera_scroll_speed
			
			next_position = camera_3d.far - camera_scroll_speed
			if scroll_mode == "far" and next_position >= frustum_min and next_position > camera_3d.near:
				camera_3d.far -= camera_scroll_speed
				
	# Update the camera position to orbit around the object
	update_camera_position()
	if locked:
		update_player_position()

# Update camera position to orbit around the object
func update_camera_position() -> void:
	# Calculate the new position of the camera based on the object's rotation
	var angle = rotation.y  # The angle of the object around the Y-axis
	var offset = Vector3(-sin(angle) * camera_distance, 0, -cos(angle) * camera_distance)
	
	# Position the camera in the correct spot based on the angle
	camera_3d.global_transform.origin = center.global_transform.origin + offset
	camera_3d.look_at(center.global_transform.origin, Vector3.UP)

func update_player_position() -> void:
	# Calculate the new position of the camera based on the object's rotation
	var angle = rotation.y  # The angle of the object around the Y-axis
	var offset = Vector3(-sin(angle) * player_distance, 0, -cos(angle) * player_distance)
	
	# Position the camera in the correct spot based on the angle
	player.position = global_transform.origin + offset
	player.look_at(global_transform.origin, Vector3.UP)
