extends Control

var _menu_index: int = 0

# references to nodes relevant for the options menu
@onready var _player_camera = get_node("/root/Main/Player/SpringArm3D")
# TODO alternatively maybe a PlayerOptions node?

func _input(event):
	if event.is_action_pressed("pause"):
#		_resume() # commented out because of glitch: pressing the button registers
		# that the menu should be closed, thus closing the menu and unpausing the
		# game, but in-game it is also registered, thus pausing the game again
		pass
	elif event.is_action_pressed("ui_cancel"):
		_navigate_back()

func _navigate_back():
	print("called")
	match _menu_index:
		0:
			_resume()
		1:
			_menu_index = 0
			$WeaponsMenu.hide()
			$MainMenu.show()
			$MainMenu/ButtonWeapons.grab_focus()
		2:
			_menu_index = 0
			$GadgetsMenu.hide()
			$MainMenu.show()
			$MainMenu/ButtonGadgets.grab_focus()
		3:
			_menu_index = 0
			$QuickSelectMenu.hide()
			$MainMenu.show()
			$MainMenu/ButtonQuickSelect.grab_focus()
		4:
			_menu_index = 0
			$ItemsMenu.hide()
			$MainMenu.show()
			$MainMenu/ButtonItems.grab_focus()
		5:
			_menu_index = 0
			$OptionsMenu.hide()
			$MainMenu.show()
			$MainMenu/ButtonOptions.grab_focus()
		51:
			_menu_index = 5
			$ControlsMenu.hide()
			$OptionsMenu.show()
			$OptionsMenu/MarginContainer/Container/ViewControlsButton.grab_focus()

func open():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_menu_index = 0
	# hide everything just to be safe
	$WeaponsMenu.hide()
	$GadgetsMenu.hide()
	$ItemsMenu.hide()
	$OptionsMenu.hide()
	$ControlsMenu.hide()
	
	$MainMenu.show()
	$MainMenu/ButtonResume.grab_focus()

func _on_button_resume_pressed():
	_resume()

func _on_button_reload_pressed():
	get_node("/root/Main").reload()
	_resume()

func _on_button_weapons_pressed():
	_menu_index = 1
	$MainMenu.hide()
	$WeaponsMenu.show()

func _on_button_gadgets_pressed():
	_menu_index = 2
	$MainMenu.hide()
	$GadgetsMenu.show()

func _on_button_quick_select_pressed():
	_menu_index = 3
	$MainMenu.hide()
	$QuickSelectMenu.show()

func _on_button_items_pressed():
	_menu_index = 4
	$MainMenu.hide()
	$ItemsMenu.show()

func _on_button_options_pressed():
	_menu_index = 5
	$MainMenu.hide()
	$OptionsMenu.show()
	$OptionsMenu/MarginContainer/Container/MouseSensitivitySlider.grab_focus()
	# set options such as sliders
	$OptionsMenu/MarginContainer/Container/MouseSensitivitySlider.value = _player_camera.mouse_sensitivity
	$OptionsMenu/MarginContainer/Container/ControllerSensitivitySlider.value = _player_camera.stick_sensitivity

func _resume():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_quit_pressed():
	get_tree().quit()

func _on_options_back_button_pressed():
	# save settings
	_player_camera.mouse_sensitivity = $OptionsMenu/MarginContainer/Container/MouseSensitivitySlider.value
	_player_camera.stick_sensitivity = $OptionsMenu/MarginContainer/Container/ControllerSensitivitySlider.value
	_navigate_back()

func _on_english_pressed():
	TranslationServer.set_locale("en")

func _on_german_pressed():
	TranslationServer.set_locale("de")

func _on_view_controls_button_pressed():
	_menu_index = 51
	$OptionsMenu.hide()
	$ControlsMenu.show()
