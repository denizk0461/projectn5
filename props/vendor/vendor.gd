extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_vendor_state(true)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.set_vendor_state(false)
