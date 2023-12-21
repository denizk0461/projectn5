extends Control

var _player_health_max: int
var _player_health_current: int
var _health_points: Array
@onready var health_container_0 = $Container0
@onready var health_container_1 = $Container1

func setup_health(max: int):
	_player_health_max = max
	_player_health_current = max
	_health_points.clear()
	for i in max:
		var health_point = preload("res://player/ui/hud/health/health_point.tscn").instantiate()
		health_point.set_active(true)
		var first_line_max = 4
		if max == 5 or max == 6:
			first_line_max = 3
		if i < first_line_max:
			health_container_0.add_child(health_point)
		else:
			health_container_1.add_child(health_point)
		_health_points.append(health_point)

func _set_health():
	for i in _health_points.size():
		_health_points[i].set_active(i < _player_health_current)

func heal():
	if _player_health_current < _player_health_max:
		_player_health_current += 1
		_set_health()

func take_damage() -> bool:
	if _player_health_current > 0:
		_player_health_current -= 1
		_set_health()
		return _player_health_current <= 0
	else:
		return true # if the health is 0 then the player is dead for sure
