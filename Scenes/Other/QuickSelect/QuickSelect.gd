extends Control

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_released("quick_select"):
		get_tree().paused = false
		self.hide()

func activate():
	self.show()
	$Item0.grab_focus()

func _process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if not direction == Vector2.ZERO and rad_to_deg(direction.angle()) > 10.0:
#		0.0:
#			$Item0.grab_focus()
#		45.0:
#			$Item1.grab_focus()
#		90.0:
#			$Item2.grab_focus()
#		135.0:
		$Item3.grab_focus()
#		180.0:
#			$Item4.grab_focus()
#		225.0:
#			$Item5.grab_focus()
#		270.0:
#			$Item6.grab_focus()
#		315.0:
#			$Item7.grab_focus()

func _on_item_0_pressed():
	print('yes')
