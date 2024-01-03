extends Node3D

@export_group("Gun Statistics")
@export_range(101, 199) var gun_id: int
@export_range(1, 3) var gun_level: int = 1
#@export var ammo_id: int
@export var max_ammo: int

@export_group("Projectile")
#@export var projectile_name: String = "AngryIcosphere"
@export var projectile_speed: float
@export var despawn_after_secs: float = 2.0

@export_group("Misc")
@export var shoot_timeout: float = 0.3
@export_enum("Semiauto", "Automatic") var shoot_type: String
@export var icon: CompressedTexture2D

var _may_shoot: bool = true
var _may_shoot_automatic: bool = false
var _automatic_timeout: bool = false

var player_rotation: float

@onready var _projectiles = get_node("/root/Main/Projectiles")
@onready var _inventory = get_node("/root/Main/Player/Inventory")

#signal get_player_rotation() -> ?

func start_shooting():
	match shoot_type:
		"Automatic":
			_may_shoot_automatic = true
		_: # semiauto
			_shoot_once()

func _process(delta):
	if _may_shoot_automatic and not _automatic_timeout:
		_shoot_once()
		_automatic_timeout = true
		$Timer.start(shoot_timeout)
		await $Timer.timeout
		_automatic_timeout = false

func _shoot_once():
	var is_loaded = _inventory.shoot_gun(gun_id)
	if _may_shoot and is_loaded:
		$SFX/Shoot.play()
		var direction: Vector3
		if not $ProjectileSpawn/AutoTarget == null and $ProjectileSpawn/AutoTarget.is_targeting_enemy():
			var enemy_global_position = $ProjectileSpawn/AutoTarget.get_targeted_enemy_global_position()
			if enemy_global_position == Vector3.ZERO:
				direction = _get_default_projectile_direction()
			else:
				direction = (enemy_global_position - $ProjectileSpawn.global_position).normalized()
		else:
			direction = _get_default_projectile_direction()
		var projectile = load(ItemManager.get_projectile_path(gun_id, gun_level)).instantiate()
		projectile.position = $ProjectileSpawn.global_position
		projectile.linear_velocity = direction * projectile_speed
		_projectiles.add_child(projectile)
		
		if shoot_type == "Semiauto":
			_pause_shooting()
		
		_despawn(projectile)
	elif not is_loaded:
		$SFX/Empty.play()
		_may_shoot_automatic = false

func _get_default_projectile_direction() -> Vector3:
	return -Vector3.FORWARD.rotated(Vector3.UP, player_rotation)

func stop_shooting():
	_may_shoot_automatic = false
	$Timer.stop()
	$Timer.emit_signal("timeout")

#func shoot():

func _pause_shooting():
	_may_shoot = false
	await get_tree().create_timer(shoot_timeout).timeout
	_may_shoot = true

func _despawn(projectile):
	await get_tree().create_timer(despawn_after_secs).timeout
	projectile.queue_free()
