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
var _targeted_npc: Node3D = null
var _ground_normal: Vector3
var _floor_plane = Plane(Vector3.UP)
var _xz = Vector3.ZERO
var _max_player_health: int = 4 # total max that the player can achieve in game is 8
var _is_second_jump: bool = false

@onready var _player_health: int = _max_player_health
@onready var _message_handler = $HUD/MessageHandler

# TODOs
# prevent jumping on slope when sliding down
# disallow double jumping if close to the ground (maybe?)

signal health_changed(new_health: int)

func _ready():
	$Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Inventory.switch_to_melee()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$SpringArm3D/GameplayCamera.make_current()
	$HUD/PlayerHUD.setup_health_bar(_max_player_health)
	$SpringArm3D.add_excluded_object(self)
	_message_handler.show_timed_message("hello world!")

func _input(event):
	if event.is_action_pressed("jump") and _jump_count < 2:
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
			
			_is_second_jump = _jump_count == 2
			disallow_second_jump_after(0.6)
	
	elif event.is_action_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		$GUI/PauseMenu.open()
	
	elif event.is_action_pressed("quick_select_action"):
		if not _targeted_npc == null:
			_position_player_for_conversation()
			#$HUD/TalkToNPC.hide()
			$HUD/DialogueBox.start_dialogue(_targeted_npc.npc_name, _targeted_npc.dialogue)
			$HUD/DialogueBox.show()
			$Pivot/DialogueCamera.make_current()
		else:
			$GUI/QuickSelect.prepare_menu()
			$GUI/QuickSelect.activate()
		get_tree().paused = true
	
	elif event.is_action_pressed("melee"):
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

func disallow_second_jump_after(seconds: float):
	var jc = _total_jump_count
	# only allow the player to jump a second jump within a few seconds of the first jump
	# TODO replace this with a Timer node in the scene tree
	# this creates a new Timer every time it is called
	await get_tree().create_timer(seconds).timeout
	# check if the player has jumped since the timer started. this is to prevent
	# cancelling later jumps
	if jc == _total_jump_count and _jump_count != 2 and not is_on_floor():
		_jump_count = 2

func _shoot():
	if $Inventory.is_melee_equipped:
		# don't shoot upon equipping the gun
		$Inventory.switch_to_gun()
	else:
		$Pivot/EquippedItem.get_node("Item").shoot() # convert to signal

func _process(delta):
	# position camera relative to the player
	$SpringArm3D.position = position
	
	# TODO rewrite this for semi-automatic and automatic weapons
	if Input.is_action_just_pressed("shoot") and not _is_second_jump:
		_shoot()

func _physics_process(delta):
	var direction_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = Vector3(direction_2d.x, 0.0, direction_2d.y)

	if direction == Vector3.ZERO:
		pass
		# what did I want to do here again?
	else:
		direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
		if not Input.is_action_pressed("strafe"):
			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(direction.x, direction.z), _rotation_speed * delta)
	
	var show_crosshair: bool = false
	if Input.is_action_pressed("strafe"):
		show_crosshair = true
		var rotation_rads = $SpringArm3D.rotation.y
		var look_direction = Vector3(sin(rotation_rads), 0.0, cos(rotation_rads))#.rotated(Vector3.UP, deg_to_rad(180.0))
		$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(look_direction.x, look_direction.z) + deg_to_rad(180.0), _rotation_speed * delta)
	
	if show_crosshair:
		$HUD/CrosshairContainer.show()
	else:
		$HUD/CrosshairContainer.hide()
	
	# slope direction correction
	_ground_normal = $GroundAngleCast.get_collision_normal()
	_floor_plane.normal = _ground_normal
	_xz = _target_velocity
	
	if _floor_plane and is_on_floor():
		# TODO standing on sans crashes the game because of these lines!
		# what to do when intersection is null?
#		print("%s + %s" % [Time.get_ticks_msec(), _floor_plane])
		var x = _floor_plane.intersects_segment(Vector3.RIGHT + Vector3.UP * 2.0, Vector3.RIGHT + Vector3.DOWN * 2.0).normalized()
		var z = _floor_plane.intersects_segment(Vector3.BACK + Vector3.UP * 2.0, Vector3.BACK + Vector3.DOWN * 2.0).normalized()
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
	if ($GroundAngleCast.get_collider() 
			and $GroundAngleCast.get_collision_normal().angle_to(Vector3.UP) > floor_max_angle
	):
		_jump_count = 2
		_is_second_jump = true
	
	if is_on_floor():
		if not _wants_to_jump:
			_target_velocity.y = 0.0
			_has_jumped = false
	else:
		if _target_velocity.y > _max_falling_velocity:
			_target_velocity.y = _target_velocity.y - (_fall_acceleration * delta)
	
	
	velocity = _target_velocity
	move_and_slide()
	
	if is_on_floor():
		_wants_to_jump = false
		_jump_count = 0
		_is_second_jump = false

func target_npc(npc: Node3D):
	_targeted_npc = npc
	_message_handler.show_message("HUD_TALK_TO_NPC")

func forget_npc():
	_targeted_npc = null
	_message_handler.hide_message()

# position player in front of NPC and face NPC for conversation
func _position_player_for_conversation():
	var new_player_position = (Vector3.BACK * 2.0).rotated(Vector3.UP, _targeted_npc.rotation.y) + _targeted_npc.position
	position = new_player_position
	var delta = (position - _targeted_npc.position)
	$Pivot.rotation.y = atan2(delta.x, delta.z) + deg_to_rad(180.0)
	velocity = Vector3.ZERO

func _take_damage():
	if _player_health > 0:
		_player_health -= 1
		health_changed.emit(_player_health)
	
	if _player_health == 0:
		_die()
	# timeout (invincibility frames)

func _heal():
	if _player_health < _max_player_health:
		_player_health += 1
		health_changed.emit(_player_health)

func _die():
	print("you are DEAD muhahahhahahha!")
	pass # TODO
