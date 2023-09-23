extends Node3D

var items: Array[int] = []
var items_assignments: Dictionary = {
	100: "",
}
var item_resource_path: String = "res://Items/%s.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	# load inventory items perhaps?
	pass # Replace with function body.

func load_item(id: int) -> PackedScene:
	return load(item_resource_path % items_assignments[id])

func collect_item(id: int):
	items.append(id)

func get_collected_item_ids() -> Array[int]:
	return items
