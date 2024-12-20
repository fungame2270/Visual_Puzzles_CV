extends StaticBody3D

func interact(caller):
	get_parent().visible = false
	caller.toggle_flashlight()
