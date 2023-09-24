extends Node3D

@export var projectile_offset: Vector3 = Vector3.ZERO
@export var projectile_name: String = "AngryIcosphere"
@export var projectile_speed: float
@export var despawn_after_secs: float = 2.0
var _projectile_path: String = "res://Items/Weapons/Projectiles/%s.tscn"

func shoot(direction: Vector3):
	var projectile = load(_projectile_path % projectile_name).instantiate()
	projectile.position = projectile_offset
#	projectile.velocity = direction * projectile_speed
	add_child(projectile)
	
	await get_tree().create_timer(despawn_after_secs).timeout
	projectile.queue_free()
