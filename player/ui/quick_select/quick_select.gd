extends Control

var _is_active: bool = false
var _quick_select_items: Array[int]
var _index_to_equip: int = -1

signal item_equipped(item_id: int)

func prepare_menu():
	_quick_select_items = get_node("../../Inventory").quick_select
	for index in _quick_select_items.size():
		if not _quick_select_items[index] == -1:
			
			var texture = ItemManager.get_icon_path(_quick_select_items[index])
			get_node("Item%s/Slot" % index).texture = load(texture)

func _input(event):
	if event.is_action_released("quick_select_action") and _is_active:
		_equip_new_item()
		_is_active = false
		get_tree().paused = false
		self.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if _is_active:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var input_angle = rad_to_deg(direction.angle_to(Vector2.UP))
		if input_angle > 0.0:
			input_angle -= 360.0
		input_angle *= -1
		if not direction == Vector2.ZERO:
			if input_angle < 23.0 and not _quick_select_items[0] == -1:
				$Item0.grab_focus()
			elif input_angle < 68.0 and not _quick_select_items[1] == -1:
				$Item1.grab_focus()
			elif input_angle < 112.0 and not _quick_select_items[2] == -1:
				$Item2.grab_focus()
			elif input_angle < 157.0 and not _quick_select_items[3] == -1:
				$Item3.grab_focus()
			elif input_angle < 202.0 and not _quick_select_items[4] == -1:
				$Item4.grab_focus()
			elif input_angle < 247.0 and not _quick_select_items[5] == -1:
				$Item5.grab_focus()
			elif input_angle < 292.0 and not _quick_select_items[6] == -1:
				$Item6.grab_focus()
			elif input_angle < 337.0 and not _quick_select_items[7] == -1:
				$Item7.grab_focus()
			elif not _quick_select_items[0] == -1:
				$Item0.grab_focus()

func _equip_new_item():
	if (not _index_to_equip == -1
			and not _quick_select_items[_index_to_equip] == -1
	):
		item_equipped.emit(_quick_select_items[_index_to_equip])

func activate():
	_is_active = true
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_item_0_mouse_entered():
	if not _quick_select_items[0] == -1:
		$Item0.grab_focus()

func _on_item_0_focus_entered():
	_index_to_equip = 0

func _on_item_1_mouse_entered():
	if not _quick_select_items[1] == -1:
		$Item1.grab_focus()

func _on_item_1_focus_entered():
	_index_to_equip = 1

func _on_item_2_mouse_entered():
	if not _quick_select_items[2] == -1:
		$Item2.grab_focus()

func _on_item_2_focus_entered():
	_index_to_equip = 2

func _on_item_3_mouse_entered():
	if not _quick_select_items[3] == -1:
		$Item3.grab_focus()

func _on_item_3_focus_entered():
	_index_to_equip = 3

func _on_item_4_mouse_entered():
	if not _quick_select_items[4] == -1:
		$Item4.grab_focus()

func _on_item_4_focus_entered():
	_index_to_equip = 4

func _on_item_5_mouse_entered():
	if not _quick_select_items[5] == -1:
		$Item5.grab_focus()

func _on_item_5_focus_entered():
	_index_to_equip = 5

func _on_item_6_mouse_entered():
	if not _quick_select_items[6] == -1:
		$Item6.grab_focus()

func _on_item_6_focus_entered():
	_index_to_equip = 6

func _on_item_7_mouse_entered():
	if not _quick_select_items[7] == -1:
		$Item7.grab_focus()

func _on_item_7_focus_entered():
	_index_to_equip = 7
