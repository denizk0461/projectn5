extends Node3D

var items: Array[int] = []
var items_assignments: Dictionary = {
	101: "Weapons/PurpleGun",
	401: "Weapons/InanimateCarbonRod",
}
var item_resource_path: String = "res://Items/%s.tscn"

# must be length 8
var quick_select: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1]
var equipped_melee: int = 401
var equipped_gun: int = 101

# 0 = melee
# 1 = gun
# defaults to melee
var active_item: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# load inventory items perhaps?
	pass # Replace with function body.

func load_item(id: int):
	var equipped_item_node = get_node("../Pivot/EquippedItem")
	print(item_resource_path % items_assignments[id])
	var item = load(item_resource_path % items_assignments[id]).instantiate()
	var currently_equipped_item = equipped_item_node.get_child(0)
	if not currently_equipped_item == null:
		equipped_item_node.remove_child(currently_equipped_item)
	equipped_item_node.add_child(item)

func load_melee():
	load_item(equipped_melee)

func load_gun():
	load_item(equipped_gun)

func collect_item(id: int):
	items.append(id)

func get_collected_item_ids() -> Array[int]:
	return items
