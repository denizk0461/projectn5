extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.show_vendor_message()

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.hide_vendor_message()
