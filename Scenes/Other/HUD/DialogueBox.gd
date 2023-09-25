extends Control

var _dialogue: Array[String]
var _index: int = -1
var _is_active: bool = false

func start_dialogue(npc_name: String, dialogue: Array[String]):
	_is_active = true
	_dialogue = dialogue
	_index = 0
	$PersonLabel.text = npc_name
	$DialogueLabel.text = _dialogue[_index]

func _next_dialogue():
	_index += 1
	if _index == _dialogue.size():
		_end_dialogue()
	else:
		$DialogueLabel.text = _dialogue[_index]

func _input(event):
	if event.is_action_pressed("ui_accept") and _is_active:
		_next_dialogue()

func _end_dialogue():
	_is_active = false
	get_tree().paused = false
	hide()
	get_node("/root/Main/Player/SpringArm3D/GameplayCamera").make_current()
