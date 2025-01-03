extends StaticBody3D

func interact(caller):
	get_parent().visible = false
	caller.toggle_flashlight()
	caller.toggle_flashlight_label()
	queue_free()
