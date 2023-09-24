extends Control

var _menu_index: int = 0

func _input(event):
	if event.is_action_pressed("pause"):
#		_resume()
		pass
	elif event.is_action_pressed("ui_cancel"):
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

func open():
	show()
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
	get_tree().root.get_child(0).reload()
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

func _resume():
	get_tree().paused = false
	hide()


func _on_button_quit_pressed():
	get_tree().quit()
