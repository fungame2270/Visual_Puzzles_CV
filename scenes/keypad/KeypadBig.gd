extends Node3D

var locked = false
var disabled = false
@onready var password_label: Label = $PasswordViewport/PasswordLabel
var player: CharacterBody3D 
@export var answer: String
@export var door : StaticBody3D

func _ready() -> void:
	password_label.text = ""

func update_label(value):
	if len(password_label.text) == 5:
		password_label.text = value
	else:
		password_label.text += value
	
	if len(password_label.text) == 5:
		if password_label.text == answer:
			print("correct")
			locked = false
			disabled = true
			player.lock()
			door.open()
		

func _input(event):
	if event is InputEventKey and event.pressed and locked:
		var key_pressed = event.as_text_keycode()
		if key_pressed.is_valid_int():
			update_label(key_pressed)
		
		if key_pressed == "Backspace":
			password_label.text = ""

func interact(caller):
	player = caller
	if not disabled:
		if locked:
			locked = false
			player.lock()
		else:
			locked = true
			player.lock()
