extends Control

var _is_active: bool = false
var _quick_select_items: Array[int]
var _index_to_equip: int = -1

signal on_quick_select_closed(item_id: int)

func prepare_menu():
	_quick_select_items = get_node("../../Inventory").quick_select
	for index in _quick_select_items.size():
		if not _quick_select_items[index] == -1:
			var texture = ItemManager.get_icon_path(_quick_select_items[index])
			get_node("Item%s/Slot" % index).texture = load(texture)

func _input(event):
	if _is_active:
		if event.is_action_released("quick_select_action"):
			_equip_new_item()
			_is_active = false
			get_tree().paused = false
			self.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		elif event is InputEventMouseMotion:
			var direction = event.position - $ArrowContainer.global_position
			var input_angle = rad_to_deg(direction.angle_to(Vector2.UP))
			if input_angle > 0.0:
				input_angle -= 360.0
			input_angle *= -1
			print(input_angle)
			$ArrowContainer.rotation_degrees = input_angle
		
		elif event is InputEventJoypadMotion:
			var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var input_angle = rad_to_deg(direction.angle_to(Vector2.UP))
			if input_angle > 0.0:
				input_angle -= 360.0
			input_angle *= -1
			if not direction == Vector2.ZERO:
				$ArrowContainer.rotation_degrees = input_angle
			
		var arrow_angle = $ArrowContainer.rotation_degrees
		if (_is_in_range(arrow_angle, 0, 23) or arrow_angle >= 337.0) and not _quick_select_items[0] == -1:
			$Item0.grab_focus()
		elif _is_in_range(arrow_angle, 23, 68) and not _quick_select_items[1] == -1:
			$Item1.grab_focus()
		elif _is_in_range(arrow_angle, 68, 112) and not _quick_select_items[2] == -1:
			$Item2.grab_focus()
		elif _is_in_range(arrow_angle, 112, 157) and not _quick_select_items[3] == -1:
			$Item3.grab_focus()
		elif _is_in_range(arrow_angle, 157, 202) and not _quick_select_items[4] == -1:
			$Item4.grab_focus()
		elif _is_in_range(arrow_angle, 202, 247) and not _quick_select_items[5] == -1:
			$Item5.grab_focus()
		elif _is_in_range(arrow_angle, 247, 292) and not _quick_select_items[6] == -1:
			$Item6.grab_focus()
		elif _is_in_range(arrow_angle, 292, 337) and not _quick_select_items[7] == -1:
			$Item7.grab_focus()

func _is_in_range(value: float, from: float, to: float) -> bool:
	return (value >= from and value < to)

func _equip_new_item():
	if (not _index_to_equip == -1 and not _quick_select_items[_index_to_equip] == -1):
		on_quick_select_closed.emit(_quick_select_items[_index_to_equip])

func activate():
	_is_active = true
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_item_0_focus_entered():
	_index_to_equip = 0

func _on_item_1_focus_entered():
	_index_to_equip = 1

func _on_item_2_focus_entered():
	_index_to_equip = 2

func _on_item_3_focus_entered():
	_index_to_equip = 3

func _on_item_4_focus_entered():
	_index_to_equip = 4

func _on_item_5_focus_entered():
	_index_to_equip = 5

func _on_item_6_focus_entered():
	_index_to_equip = 6

func _on_item_7_focus_entered():
	_index_to_equip = 7
