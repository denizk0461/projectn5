extends Control

const MESSAGE_REGULAR: int = 0
const MESSAGE_SMALL: int = 1
const TIME_NORMAL: float = 2.0
const TIME_INDEFINITE: float = -1.0
const TWEEN_TIME: float = 0.09
@onready var _text_field = $Message/Margin/TextField
@onready var _text_field_small = $MessageSmall/Margin/TextField

# shows a timed message
func show_timed_message(message_type: int, text: String, time: float = TIME_NORMAL):
	var timer: Timer
	match message_type:
		MESSAGE_SMALL:
			timer = $MessageSmall/Timer
		_:
			timer = $Message/Timer
	show_message(message_type, text)
	timer.start(time)
	await timer.timeout
	hide_message(message_type)

# shows a message indefinitely. can be stopped with hide_message
func show_message(message_type: int, text: String):
	var property
	match message_type:
		MESSAGE_SMALL:
			property = $MessageSmall
			_text_field_small.text = text
		_:
			property = $Message
			_text_field.text = text
	get_tree().create_tween().tween_property(property, "modulate:a", 1, TWEEN_TIME)

# hides a message.
# instantly: if true, instantly hides message without animation
func hide_message(message_type: int, instantly: bool = false):
	var property
	match message_type:
		MESSAGE_SMALL:
			property = $MessageSmall
		_:
			property = $Message
	if instantly:
		property.modulate.a = 0
	else:
		# TODO? this function call crashes the game every time I quit the game
		# without a timer set, and I don't see why it should do that, so let's
		# just pretend that nothing has ever happened
		get_tree().create_tween().tween_property(property, "modulate:a", 0, TWEEN_TIME)

# hides messages for temporary purposes, such as opening a menu
func hide_messages_instantly():
	self.modulate.a = 0

# shows messages after temporarily hiding them using hide_messages_instantly().
# this MUST be called after hide_messages_instantly(), else no messages will be
# visible afterwards
func show_messages_instantly():
	self.modulate.a = 1
