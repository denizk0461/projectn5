extends Node3D

@export var projectile_offset: Vector3 = Vector3.ZERO
@export var projectile_name: String = "AngryIcosphere"
@export var projectile_speed: float
@export var despawn_after_secs: float = 2.0
@export var shoot_timeout: float = 0.3
@export_enum("Semi", "Automatic") var shoot_type: String
var _projectile_path: String = "res://Items/Weapons/Projectiles/%s.tscn"
var _may_shoot: bool = true

func shoot():
	if _may_shoot:
		var direction = ($ProjectileSpawn.global_position - $ProjectileVelocityHelper.global_position).normalized()
		var projectile = load(_projectile_path % projectile_name).instantiate()
		projectile.position = $ProjectileSpawn.global_position
		projectile.linear_velocity = direction * projectile_speed
		get_node("/root/Main/Projectiles").add_child(projectile)
		
		if shoot_type == "Semi":
			_pause_shooting()
		
		_despawn(projectile)

func _pause_shooting():
	_may_shoot = false
	await get_tree().create_timer(shoot_timeout).timeout
	_may_shoot = true

func _despawn(projectile):
	await get_tree().create_timer(despawn_after_secs).timeout
	projectile.queue_free()
