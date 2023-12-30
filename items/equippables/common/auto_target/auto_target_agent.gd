extends Area3D

var _colliders: Array[Node3D] = []
var _targeted_enemy_index: int = -1
var _shortest_distance: int = 1000
#@onready var _auto_target_sprite = get_tree().get_root().get_node("AutoTargetSprite")

func _process(delta):
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
	if body.is_in_group("enemy"):
		_colliders.append(body)
		#print(_colliders.size())

func _on_body_exited(body):
	if body.is_in_group("enemy"):
		_colliders.erase(body)
		#print(_colliders.size())
