extends Control

var _ammo_template: String = "[b]%s[/b] /%s"
var _max_ammo: int
var _health_points: Array

func set_ammo_counter(current_ammo: int):
	show_ammo_counter()
	$AmmoPanel/CountLabel.bbcode_text = _ammo_template % [current_ammo, _max_ammo]

func show_ammo_counter():
	$AmmoPanel.show()

func hide_ammo_counter():
	$AmmoPanel.hide()

func setup_gun(max_ammo: int, icon: CompressedTexture2D):
	self._max_ammo = max_ammo
	$AmmoPanel/Icon.texture = icon

func setup_health_bar(max: int):
	_health_points.clear()
	var health_container_0 = get_node("HealthBarContainer/Bar0")
	var health_container_1 = get_node("HealthBarContainer/Bar1")
	for i in max:
		var health_point = preload("res://Scenes/Other/HUD/HealthPoint.tscn").instantiate()
		health_point.set_active(true)
		var first_line_max = 4
		if max == 5 or max == 6:
			first_line_max = 3
		if i < first_line_max:
			health_container_0.add_child(health_point)
		else:
			health_container_1.add_child(health_point)
		_health_points.append(health_point)

func _set_health(new_health: int):
	for i in _health_points.size():
		_health_points[i].set_active(i < new_health)

#func set_health_point(index: int, is_active: bool):
#	_health_points[index].set_active(is_active)


func _on_player_health_changed(new_health):
	_set_health(new_health)
