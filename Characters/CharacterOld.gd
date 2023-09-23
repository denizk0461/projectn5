extends RigidBody3D

var speed: float = 5.0
var gravity: float = 9.81
var v_speed: float = 0.0
var has_movement_changed: bool = false

var velocity_x: float = 0.0
var velocity_z: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	# movement
	if event.is_action_pressed("move_forward"):
		velocity_z -= speed
		has_movement_changed = true
	if event.is_action_released("move_forward"):
		velocity_z += speed
		has_movement_changed = true
	if event.is_action_pressed("move_backwards"):
		velocity_z += speed
		has_movement_changed = true
	if event.is_action_released("move_backwards"):
		velocity_z -= speed
		has_movement_changed = true
	if event.is_action_pressed("move_left"):
		velocity_x -= speed
		has_movement_changed = true
	if event.is_action_released("move_left"):
		velocity_x += speed
		has_movement_changed = true
	if event.is_action_pressed("move_right"):
		velocity_x += speed
		has_movement_changed = true
	if event.is_action_released("move_right"):
		velocity_x -= speed
		has_movement_changed = true
		
	if has_movement_changed:
		# change movement
		set_linear_velocity(Vector3(velocity_x, 0.0, velocity_z).normalized())
		has_movement_changed = false
		
	if event.is_action_pressed("jump"):
		jump()

func jump():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	# gravity
#	if is_grounded():
#		v_speed = 0.0
#	v_speed -= gravity * delta
#	position.y += v_speed
#	print(delta)
	
	
		
	
#	.set_linear_velocity(Vector3(velocity_x, 0.0, velocity_z).normalized())

func is_grounded():
	return true
