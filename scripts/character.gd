extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const mouse_sensitivity = 0.002
var locked = false
var owns_flashlight = false
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var flashlight: SpotLight3D = $Camera3D/SpotLight3D
@onready var interact_label: Label = $Label
@onready var flashlight_label: Label = $Label2
@onready var tv_label: Label = $Label3
@onready var globe_label: Label = $Label4

func toggle_flashlight():
	flashlight.visible = false if flashlight.visible else true
	if flashlight_label.visible: flashlight_label.visible = false 
	if not owns_flashlight:
		owns_flashlight = true

func set_label(text):
	interact_label.text = text

func toggle_flashlight_label():
	flashlight_label.visible = false if flashlight_label.visible else true

func toggle_tv_label():
	tv_label.visible = false if tv_label.visible else true

func toggle_globe_label():
	globe_label.visible = false if globe_label.visible else true

func lock():
	if locked:
		locked = false
	else:
		locked = true
		
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not locked:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ray_cast_3d.is_colliding():
		if Input.is_action_just_pressed("interact"):
			var collision = ray_cast_3d.get_collider()
			collision.interact(self)
		if interact_label.visible == false:
			interact_label.visible = true
	elif interact_label.visible:
		interact_label.visible = false
	
	if Input.is_action_just_pressed("flashlight") and owns_flashlight:
		toggle_flashlight()

	if locked:
		return

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
