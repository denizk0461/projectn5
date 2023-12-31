extends Node3D

var _state = {
	"quick_select": [
		-1, -1, -1, -1, -1, -1, -1, -1,
	],
}

func save():
	# assign all needed values to the _state
	_state["quick_select"] = get_parent().get_node("Inventory").quick_select
	
	# save the _state somewhere
