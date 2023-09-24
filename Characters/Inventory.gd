extends Node3D

var items: Array[int] = []
var items_assignments: Dictionary = {
	401: "Weapons/InanimateCarbonRod",
}
var item_resource_path: String = "res://Items/%s.tscn"
var quick_select: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1] # must be length 8
var equipped_hand_item: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	# load inventory items perhaps?
	pass # Replace with function body.

func load_item(id: int):
	print(item_resource_path % items_assignments[id])
	var item = load(item_resource_path % items_assignments[id]).instantiate()
	get_node("../Pivot/EquippedItem").add_child(item)

func collect_item(id: int):
	items.append(id)

func get_collected_item_ids() -> Array[int]:
	return items
