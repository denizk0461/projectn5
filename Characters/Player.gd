extends CharacterBody3D

var speed: float = 9.0
var jump_speed: float = 18.0
var move_acceleration: float = 10.0
var move_acceleration_in_air: float = 1.9
var fall_acceleration: float = 60.0
var rotation_speed: float = 18.0
var jump_count: int = 0
var total_jump_count: int = 0
var move_direction: Vector3 = Vector3.ZERO
var wants_to_jump: bool = false
var has_jumped: bool = false
var _max_falling_velocity = -160
var target_velocity = Vector3.ZERO
var _jump_velocity: float = 0.0
var is_gun_equipped: bool = false
var _targeted_npc: Node3D = null
var ground_normal: Vector3
var floor_plane = Plane(Vector3.UP)
var xz = Vector3.ZERO

var _max_player_health: int = 6 # total max that the player can achieve in game is 8
@onready var _player_health: int = _max_player_health

# TODOs
# prevent jumping on slope when sliding down
# refined mid-air jump controls
# disallow double jumping if close to the ground (maybe?)

func _ready():
	$Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Inventory.load_melee()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$SpringArm3D/GameplayCamera.make_current()
	$HUD/PlayerHUD.setup_health_bar(_max_player_health)

func _input(event):
	if event.is_action_pressed("jump") and jump_count < 2:
		target_velocity.y = jump_speed
		wants_to_jump = true
		total_jump_count += 1
		if total_jump_count > 999:
			# avoid overflow
			total_jump_count = 0
		
		# disallows the player from jumping twice if they left the floor without
		# jumping (e.g. falling off a ledge)
		if not has_jumped and not is_on_floor():
			jump_count = 2
		else:
			jump_count += 1
			has_jumped = true
			
			disallow_second_jump_after(0.6)
	
	elif event.is_action_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		$GUI/PauseMenu.open()
	
	elif event.is_action_pressed("quick_select_action"):
		if _targeted_npc == null:
			$GUI/QuickSelect.activate()
		else:
			_position_player_for_conversation()
			$HUD/TalkToNPC.hide()
			$HUD/DialogueBox.start_dialogue(_targeted_npc.npc_name, _targeted_npc.dialogue)
			$HUD/DialogueBox.show()
			$Pivot/DialogueCamera.make_current()
		get_tree().paused = true
	
	elif event.is_action_pressed("melee"):
		if is_gun_equipped:
			$Inventory.load_melee()
			is_gun_equipped = false
		# attack! 
		# attack immediately whether the melee weapon is already equipped or not
	
	elif not event is InputEventJoypadMotion and event.is_action_pressed("shoot"):
#		shoot()
		pass

func disallow_second_jump_after(seconds: float):
	var jc = total_jump_count
	# only allow the player to jump a second jump within a few seconds of the first jump
	await get_tree().create_timer(seconds).timeout
	# check if the player has jumped since the timer started. this is to prevent
	# cancelling later jumps
	if jc == total_jump_count and jump_count != 2 and not is_on_floor():
		jump_count = 2

func shoot():
	if not is_gun_equipped:
		# don't shoot upon equipping the gun
		$Inventory.load_gun()
		is_gun_equipped = true
	else:
		$Pivot/EquippedItem.get_node("Gun").shoot()

func _process(delta):
	$SpringArm3D.position = position
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	var direction_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = Vector3(direction_2d.x, 0.0, direction_2d.y)

	if direction == Vector3.ZERO:
		pass
		# what did I want to do here again?
	else:
		direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
		if not Input.is_action_pressed("strafe"):
			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(direction.x, direction.z), rotation_speed * delta)
	
	if Input.is_action_pressed("strafe"):
		var rotation_rads = $SpringArm3D.rotation.y
		var look_direction = Vector3(sin(rotation_rads), 0.0, cos(rotation_rads))#.rotated(Vector3.UP, deg_to_rad(180.0))
		$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(look_direction.x, look_direction.z) + deg_to_rad(180.0), rotation_speed * delta)
	
	# slope direction correction
	ground_normal = $GroundCast.get_collision_normal()
	floor_plane.normal = ground_normal
	xz = target_velocity
	
	if is_on_floor() and floor_plane:
		# TODO standing on sans crashes the game because of these lines!
		var x = floor_plane.intersects_segment(Vector3.RIGHT + Vector3.UP * 2.0, Vector3.RIGHT + Vector3.DOWN * 2.0).normalized()
		var z = floor_plane.intersects_segment(Vector3.BACK + Vector3.UP * 2.0, Vector3.BACK + Vector3.DOWN * 2.0).normalized()
		x *= direction.x
		z *= direction.z
		direction = (x + z).normalized()
		target_velocity.x = direction.x
		target_velocity.z = direction.y
		if direction.length() > 0:
			xz = xz.lerp(direction * speed, move_acceleration * delta)
		else:
			xz = xz.lerp(direction * speed, move_acceleration * 2.0 * delta)
		
		if target_velocity.y < 0:
			target_velocity.y = xz.y
	
	target_velocity.x = xz.x
	target_velocity.z = xz.z
	
	_jump_velocity = target_velocity.y
	target_velocity = lerp(target_velocity, direction * speed, (move_acceleration if is_on_floor() else move_acceleration_in_air) * delta)
	target_velocity.y = _jump_velocity
	
	if is_on_floor():
		if not wants_to_jump:
			target_velocity.y = 0.0
			has_jumped = false
	else:
		if target_velocity.y > _max_falling_velocity:
			target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	
	velocity = target_velocity
	move_and_slide()
	
	if is_on_floor():
		wants_to_jump = false
		jump_count = 0

func target_npc(npc: Node3D):
	_targeted_npc = npc
	$HUD/TalkToNPC.show()

func forget_npc():
	_targeted_npc = null
	$HUD/TalkToNPC.hide()

# position player in front of NPC and face NPC for conversation
func _position_player_for_conversation():
	var new_player_position = (Vector3.BACK * 2.0).rotated(Vector3.UP, _targeted_npc.rotation.y) + _targeted_npc.position
	position = new_player_position
	var delta = (position - _targeted_npc.position)
	$Pivot.rotation.y = atan2(delta.x, delta.z) + deg_to_rad(180.0)
	velocity = Vector3.ZERO

func take_damage():
	if _player_health > 0:
		_player_health -= 1
		# TODO are both necessary?
		health_changed.emit(_player_health)
#		$HUD/PlayerHUD.set_health(_player_health)
#		$HUD/PlayerHUD.set_health_point(_player_health, false)
	
	if _player_health == 0:
		_die()
	# timeout (invincibility frames)

func heal():
	if _player_health < _max_player_health:
		_player_health += 1
		health_changed.emit(_player_health)
#		$HUD/PlayerHUD.set_health_point(_player_health - 1, true)

func _die():
	print("you are DEAD muhahahhahahha!")
	pass # TODO

signal health_changed(new_health: int)
