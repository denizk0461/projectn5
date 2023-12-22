extends Node3D

func on_collected():
	get_parent().queue_free()
