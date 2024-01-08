extends Area3D

var _velocity: Vector3 = Vector3.ZERO

func start_moving(velocity: Vector3):
	_velocity = velocity

func _physics_process(delta):
	transform.origin += _velocity * delta
