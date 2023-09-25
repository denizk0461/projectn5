extends Control

var _is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_released("quick_select_action") and _is_active:
		_is_active = false
		get_tree().paused = false
		self.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func activate():
	_is_active = true
	self.show()
	$Item0.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	# grabbing the input here results in errors in other menus such as the pause menu!
#	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector2.ZERO
	
	if not direction == Vector2.ZERO and rad_to_deg(direction.angle()) > 10.0:
		pass
#		0.0:
#			$Item0.grab_focus()
#		45.0:
#			$Item1.grab_focus()
#		90.0:
#			$Item2.grab_focus()
#		135.0:
#			$Item3.grab_focus()
#		180.0:
#			$Item4.grab_focus()
#		225.0:
#			$Item5.grab_focus()
#		270.0:
#			$Item6.grab_focus()
#		315.0:
#			$Item7.grab_focus()

func _on_item_0_pressed():
	print('yes i have been pressed')
