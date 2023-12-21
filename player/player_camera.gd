extends SpringArm3D

var mouse_sensitivity: float = 3.0
var stick_sensitivity: float = 3.0

func _ready():
	set_as_top_level(true)
	rotation_degrees.x = -20.0

func _input(event):
	# mouse camera control
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * (mouse_sensitivity / 30.0)
		rotation_degrees.y -= event.relative.x * (mouse_sensitivity / 30.0)
	
		rotation_degrees.x = clamp(rotation_degrees.x, -50.0, 40.0)
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(delta):
	# controller camera control
	rotation_degrees.x -= (Input.get_action_strength("rotate_camera_down") - Input.get_action_strength("rotate_camera_up")) * stick_sensitivity
	rotation_degrees.y -= (Input.get_action_strength("rotate_camera_right") - Input.get_action_strength("rotate_camera_left")) * stick_sensitivity
	
	rotation_degrees.x = clamp(rotation_degrees.x, -50.0, 40.0)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
