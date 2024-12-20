extends StaticBody3D

var world_enviroment : WorldEnvironment

func _ready() -> void:
	var current = get_tree().get_root()
	var nodes = []
	
	while not world_enviroment:
		for child in current.get_children():
			if child is WorldEnvironment:
				world_enviroment = child
				return
			else:
				nodes.push_front(child)
		current = nodes.pop_front()

func interact(caller):
	if world_enviroment.environment.ambient_light_energy == 0:
		world_enviroment.environment.ambient_light_energy = 1
	else:
		world_enviroment.environment.ambient_light_energy = 0
