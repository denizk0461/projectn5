extends Area3D

var _colliders: Array[Node3D] = []
var _targeted_enemy_index: int = -1
var _shortest_distance: int = 1000
#@onready var _auto_target_sprite = get_tree().get_root().get_node("AutoTargetSprite")

func _process(delta):
	# rotates the hitbox for the auto target so it always faces forward
	# (the direction the character is facing)
	#global_rotation_degrees.x = 0
	print(global_rotation_degrees.x)
	#global_rotation_degrees.x = 0
	#self.global_rotation_degrees.x = 0
	#self.global_rotate(Vector3.LEFT, 120)
	
	if _colliders.is_empty():
		_targeted_enemy_index = -1
		SignalBus.on_body_remove_target.emit()
	else:
		_shortest_distance = 1000
		for i in _colliders.size():
			var distance = self.global_position.distance_to(_colliders[i].global_position)
			if distance < _shortest_distance:
				_shortest_distance = distance
				_targeted_enemy_index = i
		#print("targeted: %d" % _targeted_enemy_index)
		SignalBus.on_body_target.emit(_colliders[_targeted_enemy_index])

func _on_body_entered(body):
	if body.is_in_group("targetable"):
		_colliders.append(body)
		#print(_colliders.size())

func _on_body_exited(body):
	if body.is_in_group("targetable"):
		_colliders.erase(body)
		#print(_colliders.size())

func is_targeting_enemy() -> bool:
	return not _targeted_enemy_index == -1

func get_targeted_enemy_global_position() -> Vector3:
	if is_targeting_enemy() and _targeted_enemy_index < _colliders.size():
		var position = _colliders[_targeted_enemy_index].global_position
		position.y += _colliders[_targeted_enemy_index].get_node("CollisionShape3D").shape.height / 2
		return position
	else:
		return Vector3.ZERO
