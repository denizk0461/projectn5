extends Node3D

@export var weapon_id: int = 101

func _on_body_entered(body):
	$Collection.on_collected()
