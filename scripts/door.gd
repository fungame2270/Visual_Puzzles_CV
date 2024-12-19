extends StaticBody3D

var isOpen = false
var t = 0.0
var target_angle
var start_angle
var amount_moved = 0

func _ready() -> void:
	start_angle = rotation_degrees.y
	target_angle = rotation_degrees.y + 90

func open():
	isOpen = true

func _physics_process(delta):
	if isOpen and abs(rotation_degrees.y - target_angle) > 2.0:
		t += delta
		rotation_degrees.y = lerp_angle(start_angle, target_angle, t * 100)
