extends CharacterBody3D

var _speed: float = 9.0
var _jump_speed: float = 18.0
var _move_acceleration: float = 10.0
var _move_acceleration_in_air: float = 1.9
var _fall_acceleration: float = 60.0
var _rotation_speed: float = 18.0
var _jump_count: int = 0
var _total_jump_count: int = 0
var _move_direction: Vector3 = Vector3.ZERO
var _wants_to_jump: bool = false
var _has_jumped: bool = false
var _max_falling_velocity = -160
var _target_velocity = Vector3.ZERO
var _jump_velocity: float = 0.0
var _ground_normal: Vector3
var _floor_plane = Plane(Vector3.UP)
var _xz = Vector3.ZERO
var _max_player_health: int = 4 # TODO max_player_health should be taken from the player's save file
var _is_second_jump: bool = false
var _is_sliding: bool = false
var _is_in_front_of_vendor: bool = false
var _invincibility_timeout: float = 0.8

var _may_take_damage: bool = true
var _has_shot: bool = false

var _fov_default: float = 80.0
var _fov_strafe: float = 72.0
var _fov_lerp_speed: float = 17.0

var _strafe_timeout: float = 0.8
var _is_force_strafing: bool = false

var _lock_camera_y: bool = false
var _spring_arm_y: float = -1.0
var _cached_global_camera_position_y: float = -1.0
var _cached_global_camera_raycast_position_y: float = -1.0
var _spring_arm_lerp_speed: float = 4

var _rng = RandomNumberGenerator.new()

@onready var _player_health: int = _max_player_health
@onready var _message_handler = $HUD/MessageHandler

func _ready():
	$Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Inventory.load_equipped_item()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$SpringArm3D/GameplayCamera.make_current()
	$HUD/PlayerHUD/HealthBar.setup_health(_max_player_health)
	$SaveState.save()
	# prevent SpringArm3D (camera) from colliding with player character
	$SpringArm3D.add_excluded_object(self)
	_spring_arm_y = $SpringArm3D.position.y

func _input(event):
	if event.is_action_pressed("jump"):
		_handle_jump()
	
	elif event.is_action_pressed("pause") and not get_tree().paused:
		_message_handler.hide_messages_instantly()
		set_process_input(false)
		_pause_game()
	
	elif event.is_action_pressed("quick_select_action"):
		_message_handler.hide_messages_instantly()
		if _is_in_front_of_vendor:
			_open_vendor()
		else:
			_open_quick_select()
	
	elif event.is_action_pressed("melee"):
		_cancel_strafe_timer()
		if not $Inventory.is_melee_equipped:
			$Inventory.switch_to_melee()
		# attack! 
		# attack immediately whether the melee weapon is already equipped or not
		pass
		if is_on_floor():
			# regular attack
			pass
		else:
			# air attack
			pass
	# TODO pressing the controller trigger is triggering this every time
	# the value is changed (the trigger is depressed or released slightly,
	# changing from 0.55 to 0.54 for example)
	elif event.is_action_pressed("shoot"):
		if not _has_shot:
			_has_shot = true
			if $Inventory.is_melee_equipped:
				# don't shoot upon equipping the gun
				$Inventory.switch_to_gun()
			else:
				$Pivot/Character/BoneAttachment3D/EquippedItem/Item.start_shooting()
				_is_force_strafing = true
				_cancel_strafe_timer(true)
	elif event.is_action_released("shoot"):
		#if not _has_shot:
			#_start_strafe_timer()
		print("????")
		_has_shot = false
		if not $Inventory.is_melee_equipped:
			$Pivot/Character/BoneAttachment3D/EquippedItem/Item.stop_shooting()
			_start_strafe_timer()

func _handle_jump():
	if _jump_count < 2:
		_target_velocity.y = _jump_speed
		_wants_to_jump = true
		_total_jump_count += 1
		if _total_jump_count > 999:
			# avoid overflow
			_total_jump_count = 0
		
		# disallows the player from jumping twice if they left the floor without
		# jumping (e.g. falling off a ledge)
		if not _has_jumped and not is_on_floor():
			_jump_count = 2
		else:
			_jump_count += 1
			_has_jumped = true
			disallow_second_jump_after(0.6)
		
		_jump_state_change()

func _jump_state_change():
	match _jump_count:
		1:
			_lock_camera_y = true
			_cached_global_camera_position_y = self.global_position.y
			if $JumpRayCast3D.is_colliding():
				_cached_global_camera_raycast_position_y = $JumpRayCast3D.get_collider().global_position.y
			$Pivot/Character.first_jump()
		2:
			$Pivot/Character.second_jump()
			#$HUD/AutoTargetSprite.hide()
			_is_second_jump = true
		_: # 0
			_lock_camera_y = false
			_cached_global_camera_position_y = -1.0
			pass
			#$HUD/AutoTargetSprite.show()

func disallow_second_jump_after(seconds: float):
	var jump_count_before_timer = _total_jump_count
	# only allow the player to jump a second jump within a brief period after the first jump
	$SecondJumpTimer.start(seconds)
	await $SecondJumpTimer.timeout
	# check if the player has jumped since the timer started. this is to prevent
	# cancelling later jumps
	if jump_count_before_timer == _total_jump_count and _jump_count != 2 and not is_on_floor():
		_jump_count = 2

func _pause_game():
	get_tree().paused = true
	$GUI/PauseMenu.open()

func _open_quick_select():
	$GUI/QuickSelect.prepare_menu()
	$GUI/QuickSelect.activate()
	get_tree().paused = true

func _process(delta):
	var item = $Pivot/Character/BoneAttachment3D/EquippedItem/Item
	if not item == null:
		item.player_rotation = $Pivot.rotation.y
	
	if _lock_camera_y:
		$SpringArm3D.global_position.y = _cached_global_camera_position_y + _spring_arm_y
		if not $JumpRayCast3D.is_colliding() or not $JumpRayCast3D.get_collider().global_position.y == _cached_global_camera_raycast_position_y:
			_lock_camera_y = false
	else:
		$SpringArm3D.position.y = lerp($SpringArm3D.position.y, 0 + _spring_arm_y, _spring_arm_lerp_speed * delta)

func _physics_process(delta):
	#print(Engine.get_frames_per_second())
	var direction_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = Vector3(direction_2d.x, 0.0, direction_2d.y)

	if direction == Vector3.ZERO:
		pass
		# what did I want to do here again?
	else:
		direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
		if not Input.is_action_pressed("strafe") and not _is_force_strafing:
			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(direction.x, direction.z), _rotation_speed * delta)
	
	var show_crosshair: bool = false
	if Input.is_action_pressed("strafe") or _is_force_strafing:
		if Input.is_action_pressed("strafe"):
			_cancel_strafe_timer()
		# TODO move this into a callback
		$SpringArm3D/GameplayCamera.fov = lerp($SpringArm3D/GameplayCamera.fov, _fov_strafe, _fov_lerp_speed * delta)
		
		show_crosshair = true
		var rotation_rads = $SpringArm3D.rotation.y
		var look_direction = Vector3(sin(rotation_rads), 0.0, cos(rotation_rads))
		$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(look_direction.x, look_direction.z) + deg_to_rad(180.0), _rotation_speed * delta)
	else:
		# TODO move this into a callback
		$SpringArm3D/GameplayCamera.fov = lerp($SpringArm3D/GameplayCamera.fov, _fov_default, _fov_lerp_speed * delta)
	
	#if show_crosshair:
		#$HUD/CrosshairContainer.show()
	#else:
		#$HUD/CrosshairContainer.hide()
		
	
	# slope direction correction
	_ground_normal = $GroundAngleCast.get_collision_normal()
	_floor_plane.normal = _ground_normal
	_xz = _target_velocity
	
	if _floor_plane and is_on_floor():
		# TODO standing on sans and certain slopes crashes the game because of these lines!
		# what to do when intersection is null?
#		print("%s + %s" % [Time.get_ticks_msec(), _floor_plane])
		var x = _floor_plane.intersects_segment(Vector3.RIGHT + Vector3.UP * 2.0, Vector3.RIGHT + Vector3.DOWN * 2.0)
		var z = _floor_plane.intersects_segment(Vector3.BACK + Vector3.UP * 2.0, Vector3.BACK + Vector3.DOWN * 2.0)
		if not x == null and not z == null:
			x = x.normalized()
			z = z.normalized()
			x *= direction.x
			z *= direction.z
			direction = (x + z).normalized()
			_target_velocity.x = direction.x
			_target_velocity.z = direction.y
			if direction.length() > 0:
				_xz = _xz.lerp(direction * _speed, _move_acceleration * delta)
			else:
				_xz = _xz.lerp(direction * _speed, _move_acceleration * 2.0 * delta)
			
		if _target_velocity.y < 0:
			_target_velocity.y = _xz.y
	
	_target_velocity.x = _xz.x
	_target_velocity.z = _xz.z
	
	_jump_velocity = _target_velocity.y
	_target_velocity = lerp(_target_velocity, direction * _speed, (_move_acceleration if is_on_floor() else _move_acceleration_in_air) * delta)
	_target_velocity.y = _jump_velocity
	
	# disallow further jumping if the player lands on a steep slope
	# slope steepness is governed by CharacterController3D's floor_max_angle attribute
	_is_sliding = false
	if ($GroundAngleCast.get_collider() 
			and $GroundAngleCast.get_collision_normal().angle_to(Vector3.UP) > floor_max_angle
	):
		_jump_count = 2
		_is_second_jump = true
		_is_sliding = true
	
	if is_on_floor():
		if not _wants_to_jump:
			_target_velocity.y = 0.0
			_has_jumped = false
	else:
		if _target_velocity.y > _max_falling_velocity:
			_target_velocity.y = _target_velocity.y - (_fall_acceleration * delta)
	
	if _is_sliding:
		_target_velocity.x = 0
		_target_velocity.z = 0
	velocity = _target_velocity
	move_and_slide()
	if direction_2d == Vector2.ZERO:
		$Pivot/Character.stand_still()
	else:
		$Pivot/Character.walk()
	
	if is_on_floor():
		if _jump_count > 0:
			_jump_count = 0
			_jump_state_change()
		_wants_to_jump = false
		_is_second_jump = false

func take_damage(kill_instantly: bool = false):
	if _may_take_damage:
		# i'm just fucking around lmao
		$SFX/DamageSound.pitch_scale = _rng.randf_range(0.65, 1.15)
		$SFX/DamageSound.play()
		var is_dead = $HUD/PlayerHUD/HealthBar.take_damage(kill_instantly)
		
		if is_dead:
			_die()
		else:
			_may_take_damage = false
			$InvincibilityTimer.start(_invincibility_timeout)
			await $InvincibilityTimer.timeout
			_may_take_damage = true

func _heal():
	$HUD/PlayerHUD/HealthBar.heal()

func _die():
	print("you are DEAD muhahahhahahha!")
	get_tree().reload_current_scene()
	pass # TODO

func collect_ammo_pickup(weapon_id: int) -> bool:
	var reload_values = $Inventory.reload_gun(weapon_id)
	if reload_values["has_collected"]:
		$SFX/ReloadSound.play()
		_message_handler.show_timed_message(
			_message_handler.MESSAGE_REGULAR,
			tr("HUD_COLLECTED_AMMO").format({
				"refill_amount": reload_values["refill_amount"],
				"weapon_name": tr(ItemManager.get_item_attribute(weapon_id, 1, ItemManager.ATTR_NAME)),
			})
		)
	return reload_values["has_collected"]

func set_vendor_state(is_in_front: bool):
	_is_in_front_of_vendor = is_in_front
	if is_in_front:
		_show_vendor_message()
	else:
		_hide_vendor_message()

func _show_vendor_message():
	_message_handler.show_message(
		_message_handler.MESSAGE_SMALL,
		"MESSAGE_OPEN_VENDOR",
	)

func _hide_vendor_message(instantly: bool = false):
	_message_handler.hide_message(_message_handler.MESSAGE_SMALL, instantly)

func _open_vendor():
	_hide_vendor_message(true)
	$GUI/VendorMenu.open()
	set_process_input(false)

func _on_vendor_menu_closed():
	set_process_input(true)
	_show_vendor_message()
	_message_handler.show_messages_instantly()

func _on_pause_menu_closed():
	set_process_input(true)
	_message_handler.show_messages_instantly()

func _on_quick_select_closed(item_id):
	_message_handler.show_messages_instantly()

func _on_money_area_3d_body_entered(body):
	if body.is_in_group("money"):
		$Inventory.collect_money(body.money_value)
		body.queue_free()

func _on_inventory_gun_equipped():
	$Pivot/Character.point()

func _on_inventory_melee_equipped():
	$Pivot/Character.lower_arm()

func _start_strafe_timer():
	$StrafeTimer.start(_strafe_timeout)
	await $StrafeTimer.timeout
	_is_force_strafing = false

func _cancel_strafe_timer(keep_strafing: bool = false):
	if !$StrafeTimer.is_stopped():
		$StrafeTimer.stop()
		_is_force_strafing = keep_strafing
