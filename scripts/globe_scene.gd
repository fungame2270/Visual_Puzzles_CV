extends Node3D

@onready var player: CharacterBody3D = $"../../Player"
@onready var ligths_of_globe: Node3D = $Node3D/Pivot
@onready var globe_material: ShaderMaterial = load("res://scenes/globeScene.tscn::ShaderMaterial_5bwqa")
@onready var lights: Array[SpotLight3D] = [$Node3D/Pivot/Ligths/Portugal,$Node3D/Pivot/Ligths/Franca,
						$Node3D/Pivot/Ligths/USA,
						$Node3D/Pivot/Ligths/India,$Node3D/Pivot/Ligths/Japao]

var rotation_normalize = 0
var spikes = false
var heightmap_texture: Texture2D = preload("res://assets/textures/wold_spikes.jpg")
var normal_texture: Texture2D = preload("res://assets/textures/wold_spikes_Normal.jpg")
var default_heightmap_texture: Texture2D = preload("res://assets/textures/wold_Normal_Bump.jpg")
var default_normal_texture: Texture2D = preload("res://assets/textures/wold_Normal_Map.jpg")
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for l in lights:
		l.light_energy = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !locked:
		return
	if Input.is_action_pressed("move_left"):
		change_normalized_Rotation(0.001)
	if Input.is_action_pressed("move_right"):
		change_normalized_Rotation(-0.001)
		
	if Input.is_action_just_pressed("jump"):
		if spikes:
			globe_material.set("shader_parameter/texture_normal",default_normal_texture)
			globe_material.set("shader_parameter/texture_heightmap",default_heightmap_texture)
			globe_material.set("shader_parameter/normal_scale",0.65)
			globe_material.set("shader_parameter/heightmap_scale",0.64)
			for l in lights:
				l.light_energy = 0
		else:
			for l in lights:
				l.light_energy = 16
			randomize()  # Optional: Ensures different random numbers every run
			rotation_normalize = randf() * (0.7 - 0.5) + 0.5
			change_normalized_Rotation(0)
			globe_material.set("shader_parameter/normal_scale",1)
			globe_material.set("shader_parameter/heightmap_scale",1)
			globe_material.set("shader_parameter/texture_normal",normal_texture)
			globe_material.set("shader_parameter/texture_heightmap",heightmap_texture)
		spikes = !spikes
		
func rotation_to_degres(rotation: float) -> float:
	return rotation * 360
	
func change_normalized_Rotation(value:float) -> void:
	rotation_normalize += value
	if rotation_normalize > 1:
		rotation_normalize -= 1
	if rotation_normalize < -1:
		rotation_normalize += 1
	
	# Rotate the lights_of_globe node around the X-axis
	ligths_of_globe.rotation_degrees.y = rotation_to_degres(rotation_normalize)   # Rotate 90 degrees per second
	globe_material.set("shader_parameter/heightmap_translation", Vector2(-rotation_normalize,0))
	
func interact():
	locked = !locked
	player.lock()
	
