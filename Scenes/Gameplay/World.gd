extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload():
	$Player.position = Vector3(0.0, 0.0, 0.0)
	$Player/Pivot.look_at(Vector3(0.0, 0.0, 1.0), Vector3.UP)
	$Player/SpringArm3D.rotation_degrees.x = -20.0
	$Player/SpringArm3D.rotation_degrees.y = 0.0
