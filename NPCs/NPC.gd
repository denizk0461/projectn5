extends Node3D

@export var npc_name: String
@export var dialogue: Array[String]

func _on_dialogue_body_entered(body):
	print("entered")
	get_node("/root/Main/Player").target_npc(self)

func _on_dialogue_body_exited(body):
	print("exited")
	get_node("/root/Main/Player").forget_npc()
