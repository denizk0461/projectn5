extends Control

const TIME_NORMAL: float = 2.0
const TIME_INDEFINITE: float = -1.0

# shows a timed message
func show_timed_message(text: String, time: float = TIME_NORMAL):
	show_message(text)
	$Timer.start(time)
	await $Timer.timeout
	hide_message()

# shows a message indefinitely. can be stopped with hide_message
func show_message(text: String):
	$TextField.text = text
	self.show()

func hide_message():
	self.hide()
