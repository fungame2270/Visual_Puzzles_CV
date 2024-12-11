extends Sprite3D
@onready var tv: StaticBody3D = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(tv.rotation)
	rotation = tv.rotation
