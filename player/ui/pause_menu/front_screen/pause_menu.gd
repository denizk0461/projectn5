extends Control

var _menu_index: int = 0
var _item_to_equip: int = -1

# references to nodes relevant for the options menu
# TODO alternatively maybe a PlayerOptions node?

signal on_pause_menu_closed()
signal on_pause_menu_closed_item_selected(item_id: int)

func _input(event):
	if event.is_action_pressed("pause"):
		_resume()
	elif event.is_action_pressed("ui_cancel"):
		_navigate_back()

func _navigate_back():
	set_process_input(true)
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
		#51:
			#_menu_index = 5
			#$OptionsMenu.show()

func open():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	_menu_index = 0
	# hide everything just to be safe
	$WeaponsMenu.hide()
	$GadgetsMenu.hide()
	$ItemsMenu.hide()
	$OptionsMenu.hide()
	
	$MainMenu.show()
	$MainMenu/ButtonResume.grab_focus()

func _on_button_resume_pressed():
	_resume()

func _on_button_reload_pressed():
	#get_node("/root/Main").reload()
	_resume()
	get_tree().reload_current_scene()

func _on_button_weapons_pressed():
	set_process_input(false)
	_menu_index = 1
	$MainMenu.hide()
	$WeaponsMenu.show_and_focus()
	$WeaponsMenu.set_process_input(true)

func _on_button_gadgets_pressed():
	set_process_input(false)
	_menu_index = 2
	$MainMenu.hide()
	$GadgetsMenu.show()

func _on_button_quick_select_pressed():
	set_process_input(false)
	_menu_index = 3
	$MainMenu.hide()
	$QuickSelectMenu.show()

func _on_button_items_pressed():
	set_process_input(false)
	_menu_index = 4
	$MainMenu.hide()
	$ItemsMenu.show()

func _on_button_options_pressed():
	set_process_input(false)
	_menu_index = 5
	$MainMenu.hide()
	$OptionsMenu.show()
	$OptionsMenu.set_process_input(true)

func _resume():
	get_tree().paused = false
	set_process_input(false)
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	on_pause_menu_closed.emit()
	on_pause_menu_closed_item_selected.emit(_item_to_equip)

func _on_button_quit_pressed():
	# later in development, check if the player saved before quitting the game!
	get_tree().quit()

func _on_weapons_menu_on_weapons_menu_closed(item_id: int):
	_item_to_equip = item_id
	_navigate_back()

func _on_options_menu_on_options_menu_closed():
	_navigate_back()
