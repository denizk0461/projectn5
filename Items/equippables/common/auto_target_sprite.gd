extends Sprite2D

var _targeted_body: Node3D = null
var _hidden_position: Vector2 = Vector2(-100, -100)
@onready var _camera = get_node("../../SpringArm3D/GameplayCamera")

func _ready():
	SignalBus.on_body_target.connect(target_body)
	SignalBus.on_body_remove_target.connect(remove_target)

func _process(delta):
	if _targeted_body == null:
		self.position = _hidden_position
	else:
		var targeted_body_position = _targeted_body.position
		targeted_body_position.y += _targeted_body.get_node("CollisionShape3D").shape.height / 2
		var position_on_camera = _camera.unproject_position(targeted_body_position)
		self.position = position_on_camera

func target_body(body):
	_targeted_body = body
	print("target acquired")

func remove_target():
	_targeted_body = null
	print("target lost :(")
