extends Node3D

#signal on_ammo_collectible_collected(weapon_id: int)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.collect_ammo_pickup($Script.weapon_id):
			self.queue_free()
		else:
			pass # Timer
