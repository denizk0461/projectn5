extends Panel

@onready var _player_camera = get_node("/root/Main/Player/SpringArm3D")

signal on_options_menu_closed()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		on_options_menu_closed.emit()
		set_process_input(false)

func _ready():
	set_process_input(false)
	$OptionsContainer/Container/MouseSensitivitySlider.value = _player_camera.mouse_sensitivity
	$OptionsContainer/Container/ControllerSensitivitySlider.value = _player_camera.stick_sensitivity
	$OptionsContainer/Container/MouseSensitivitySlider.grab_focus()

func _on_english_pressed():
	TranslationServer.set_locale("en")

func _on_german_pressed():
	TranslationServer.set_locale("de")

func _on_view_controls_button_pressed():
	$OptionsContainer.hide()
	$ControlsScreen.show()
	set_process_input(false)
	$ControlsScreen.set_process_input(true)

func _on_mouse_sensitivity_slider_value_changed(value):
	_player_camera.mouse_sensitivity = value

func _on_controller_sensitivity_slider_value_changed(value):
	_player_camera.stick_sensitivity = value

func _on_controls_screen_on_controls_screen_closed():
	set_process_input(true)
	$OptionsContainer.show()
	$ControlsScreen.hide()
	$OptionsContainer/Container/ViewControlsButton.grab_focus()
	#set_process_input(true)
