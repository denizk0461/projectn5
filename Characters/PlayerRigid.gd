extends RigidBody3D

var jump_height: float = 1.9
var jump_time_peak: float = 0.4
var jump_time_descent: float = 0.3

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_peak
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_peak * jump_time_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_descent * jump_time_descent)

var speed = 9.0
var air_speed_first_jump = 3.0
var air_speed_second_jump = 2.3
var acceleration = 4.0
var air_acceleration = 4.0 # or deceleration i guess
var has_jumped: bool = false
var wants_to_jump: bool = false

# jumps that should be executed
var jump_queue: int = 0
# executed jumps
var jump_count: int = 0

var direction = Vector3.ZERO
var target_velocity = Vector3.ZERO
var floor_array = []
var rotation_speed: float = 6.0
var rotation_strafe_speed: float = 18.0

var is_on_floor = false
var floor_normal = Vector3.ZERO
var floor_plane = Plane(Vector3.UP)

var collision_test = KinematicCollision3D.new()
var roll_floor_state = false

var is_gun_equipped: bool = false
var _targeted_npc: Node3D = null

var _max_slope_angle = 36.0

func _ready():
	custom_integrator = true
	$Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Inventory.load_melee()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$SpringArm3D/GameplayCamera.make_current()
	$SpringArm3D.add_excluded_object(self)

func _process(delta):
	$SpringArm3D.position = position

func _input(event):
	if event.is_action_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		$GUI/PauseMenu.open()
	
	elif event.is_action_pressed("quick_select_action"):
		if _targeted_npc == null:
			$GUI/QuickSelect.activate()
		else:
			$HUD/TalkToNPC.hide()
			$HUD/DialogueBox.start_dialogue(_targeted_npc.npc_name, _targeted_npc.dialogue)
			$HUD/DialogueBox.show()
			$Pivot/DialogueCamera.make_current()
		get_tree().paused = true
	
	elif event.is_action_pressed("melee"):
		if is_gun_equipped:
			$Inventory.load_melee()
			is_gun_equipped = false
		pass # attack! 
		# attack immediately whether the melee weapon is already equipped or not
	
	elif not event is InputEventJoypadMotion and event.is_action_pressed("shoot"):
		shoot()
		pass

func _integrate_forces(state):
	target_velocity = linear_velocity
	
	is_on_floor = false
	
	if $GroundCast.get_collider():
		var contact_normal = $GroundCast.get_collision_normal()
		if not has_jumped and contact_normal.angle_to(Vector3.UP) <= _max_slope_angle * (PI / 180.0):
			is_on_floor = true
			has_jumped = false
			floor_normal = contact_normal
			floor_plane.normal = floor_normal
			jump_queue = 0
			jump_count = 0
	
	_roll_floor(is_on_floor)
	
	_get_input(state.step)
	
	var gravity_resistance = floor_normal if is_on_floor and not has_jumped else Vector3.UP
	target_velocity += gravity_resistance * _get_gravity() * state.step
	
	if jump_queue > jump_count:
		jump_count += 1
		target_velocity.y = jump_velocity
		is_on_floor = false
	
	if not has_jumped and test_move(global_transform, target_velocity * state.step, collision_test, 0.001, false, 1):
		if collision_test.get_normal(0).angle_to(Vector3.ZERO) <= _max_slope_angle * (PI / 180.0):
			transform.origin -= collision_test.get_remainder()
	
	linear_velocity = target_velocity

func _get_input(delta):
	var vy = target_velocity.y
	var xz = target_velocity
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y))
	
	direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
	if Input.is_action_pressed("strafe"):
		var rotation_rads = $SpringArm3D.rotation.y
		var look_direction = Vector3(sin(rotation_rads), 0.0, cos(rotation_rads))
		if direction != Vector3.ZERO:
			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(look_direction.x, look_direction.z) + deg_to_rad(180.0), rotation_strafe_speed * delta)
	else:
		if direction != Vector3.ZERO:
			# rotation based on player input
			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(direction.x, direction.z), rotation_speed * delta)

			# rotation based on character velocity
#			$Pivot.rotation.y = lerp_angle($Pivot.rotation.y, atan2(target_velocity.x, target_velocity.z), rotation_speed * delta)
	
	if is_on_floor:
		var x = floor_plane.intersects_segment(Vector3.RIGHT + Vector3.UP * 2.0, Vector3.RIGHT + Vector3.DOWN * 2.0).normalized()
		var z = floor_plane.intersects_segment(Vector3.BACK + Vector3.UP * 2.0, Vector3.BACK + Vector3.DOWN * 2.0).normalized()

		x *= direction.x
		z *= direction.z
		direction = (x + z).normalized()
		
		if direction.length() > 0:
			xz = xz.lerp(direction * speed, acceleration * delta)
		else:
			xz = xz.lerp(direction * speed, acceleration * 2.0 * delta)
		
		if target_velocity.y < 0:
			target_velocity.y = xz.y
		
	elif jump_count == 1:
		xz = xz.lerp(direction * air_speed_first_jump, air_acceleration * delta)
	elif jump_count == 2:
		xz = xz.lerp(direction * air_speed_second_jump, air_acceleration * delta)
	
	target_velocity.x = xz.x
	target_velocity.z = xz.z
	
	has_jumped = false
	
	# TODO disallow the player from jumping ~1 second after the first jump
	if Input.is_action_just_pressed("jump") and jump_queue < 2:
		wants_to_jump = true
		
		# disallows the player from jumping twice if they left the floor without
		# jumping (e.g. falling off a ledge)
		if not has_jumped and not is_on_floor:
			jump_queue = 2
		else:
			jump_queue += 1

func _get_gravity() -> float:
	return jump_gravity if target_velocity.y > 0 else fall_gravity

func _roll_floor(state):
	floor_array.push_back(state)
	if floor_array.size() > 3:
		floor_array.pop_front()
	
	var f = false
	for e in floor_array:
		if e:
			f = e
	roll_floor_state = f

func shoot():
	if not is_gun_equipped:
		# don't shoot upon equipping the gun
		$Inventory.load_gun()
		is_gun_equipped = true
	else:
		$Pivot/EquippedItem.get_node("Gun").shoot()

func target_npc(npc: Node3D):
	_targeted_npc = npc
	$HUD/TalkToNPC.show()

func forget_npc():
	_targeted_npc = null
	$HUD/TalkToNPC.hide()
