extends Panel

var _currently_used_controller_name: String = "nothing"

signal on_controls_screen_closed()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		on_controls_screen_closed.emit()
		set_process_input(false)

func _ready():
	set_process_input(false)

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
	# TODO use one self-designed layout for all controllers, and one for KBM
