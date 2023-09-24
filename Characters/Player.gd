extends CharacterBody3D

@export var speed: float = 14.0
@export var jump_speed: float = 20.0
@export var fall_acceleration: float = 60.0
@export var camera_sensitivity: int = 10
var jump_count: int = 0
var move_direction: Vector3 = Vector3.ZERO
var wants_to_jump: bool = false
var has_jumped: bool = false
@export var momentum_speed = 0.25
var _max_falling_velocity = -160

var target_velocity = Vector3.ZERO

var is_gun_equipped: bool = false

# TODOs
# make character follow slope angle to prevent jumping
# prevent jumping on slope
# slight ramp up / down when moving and stopping (momentum/inertia)
# mid-air jump controls
# carry jump momentum slightly but allow player some control
# limit max falling speed

func _ready():
	$Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Inventory.load_melee()

func _input(event):
	if event.is_action_pressed("jump") and jump_count < 2:
		target_velocity.y = jump_speed
		wants_to_jump = true
		
		# disallows the player from jumping twice if they left the floor without
		# jumping (e.g. falling off a ledge)
		if not has_jumped and not is_on_floor():
			jump_count = 2
		else:
			jump_count += 1
			has_jumped = true
	elif event.is_action_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		$GUI/PauseMenu.open()
	elif event.is_action_pressed("quick_select"):
		get_tree().paused = true
		$GUI/QuickSelect.activate()
	elif event.is_action_pressed("melee"):
		if is_gun_equipped:
			$Inventory.load_melee()
			is_gun_equipped = false
		pass # attack! 
		# attack immediately whether the melee weapon is already equipped or not
	elif not event is InputEventJoypadMotion and event.is_action_pressed("shoot"):
#		shoot()
		pass

func shoot():
	if not is_gun_equipped:
		$Inventory.load_gun()
		is_gun_equipped = true
	else:
		$Pivot/EquippedItem.get_node("Gun").shoot()
		pass # attack!
		# don't shoot upon equipping the gun

func _process(delta):
	$SpringArm3D.position = position
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	var direction_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = Vector3(direction_2d.x, 0.0, direction_2d.y)

	if direction == Vector3.ZERO:
		pass
	else:
		direction = direction.rotated(Vector3.UP, $SpringArm3D.rotation.y).normalized()
		if not Input.is_action_pressed("strafe"):
			$Pivot.look_at(position - direction, Vector3.UP)
	
	if Input.is_action_pressed("strafe"):
		var rotation_rads = $SpringArm3D.rotation.y
		var look_direction = Vector3(sin(rotation_rads), 0.0, cos(rotation_rads))#.rotated(Vector3.UP, deg_to_rad(180.0))
		$Pivot.look_at(position + look_direction, Vector3.UP)

#	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
#	else:
#
#	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backwards"):
#	else:
	
	if is_on_floor() and not wants_to_jump:
		target_velocity.y = 0.0
		has_jumped = false
	
	if is_on_floor():
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		# player should be able to point in direction of jump to increase jump 
		# length. until this is implemented, i leave this commented out
#		target_velocity.x = move_toward(target_velocity.x, 0.0, momentum_speed)
#		target_velocity.z = move_toward(target_velocity.z, 0.0, momentum_speed)
		if target_velocity.y > _max_falling_velocity:
			target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	move_and_slide()
	
	if is_on_floor():
		wants_to_jump = false
		jump_count = 0
		
