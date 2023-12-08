extends Control

const TIME_NORMAL: float = 2.0
const TIME_INDEFINITE: float = -1.0
const TWEEN_TIME: float = 0.09
@onready var _text_field = $Background/Margin/TextField

# shows a timed message
func show_timed_message(text: String, time: float = TIME_NORMAL):
	show_message(text)
	$Timer.start(time)
	await $Timer.timeout
	hide_message()

# shows a message indefinitely. can be stopped with hide_message
func show_message(text: String):
	_text_field.text = text
	get_tree().create_tween().tween_property(self, "modulate:a", 1, TWEEN_TIME)

# hides a message.
# instantly: if true, instantly hides message without animation
func hide_message(instantly: bool = false):
	if instantly:
		self.modulate.a = 0
	else:
		# FIXME this function call crashes the game every time I quit the game without a timer set – why?
		get_tree().create_tween().tween_property(self, "modulate:a", 0, TWEEN_TIME)
