extends Control

signal on_vendor_menu_closed()

func _input(event):
	if event.is_action_pressed("pause"):
		_resume()
	elif event.is_action_pressed("ui_cancel"):
		_resume() # TODO will be changed once the menu gets implemented properly

func open():
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)

func _resume():
	get_tree().paused = false
	set_process_input(false)
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	on_vendor_menu_closed.emit()
