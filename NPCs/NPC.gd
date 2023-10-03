extends Node3D

@export var npc_name: String
@export var dialogue: Array[String]

func _on_dialogue_body_entered(body):
	get_node("/root/Main/Player").target_npc(self)

func _on_dialogue_body_exited(body):
	get_node("/root/Main/Player").forget_npc()
