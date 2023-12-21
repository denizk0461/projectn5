extends Panel

var _currently_used_controller_name: String = "nothing"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_controller_name = Input.get_joy_name(0)
	
	if new_controller_name != _currently_used_controller_name:
		_currently_used_controller_name = new_controller_name
		match _currently_used_controller_name:
			"XInput Gamepad":
				$PlayStation.hide()
				$Xbox.show()
				$Nintendo.hide()
				$KBM.hide()
			"Nintendo Switch Pro Controller":
				$PlayStation.hide()
				$Xbox.hide()
				$Nintendo.show()
				$KBM.hide()
			"": # KBM
				$PlayStation.hide()
				$Xbox.hide()
				$Nintendo.hide()
				$KBM.show()
			_: # everything else, e.g. PS5 Controller
				$PlayStation.show()
				$Xbox.hide()
				$Nintendo.hide()
				$KBM.hide()
