extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(true)
		#if body.collect_ammo_pickup($Script.weapon_id):
			#self.queue_free()
