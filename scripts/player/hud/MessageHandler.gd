extends Control

const TIME_NORMAL: float = 2.0
const TIME_INDEFINITE: float = -1.0

func _ready():
	pass

# shows a timed message
func show_timed_message(text: String, time: float = TIME_NORMAL):
	show_message(text)
	$Timer.start(time)
	await $Timer.timeout
	hide_message()

# shows a message indefinitely. can be stopped with hide_message
func show_message(text: String):
	$TextField.text = text
	get_tree().create_tween().tween_property(self, "modulate:a", 1, 0.032)
	print("message is shown")
	#self.show()

func hide_message():
	pass
	print("message is hidden")
	get_tree().create_tween().tween_property(self, "modulate:a", 0, 0.032)
	#self.hide()
