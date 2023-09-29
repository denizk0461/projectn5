extends Node3D

var items: Dictionary = {
	101: true,
	401: true,
}

var gun_ammo_count: Dictionary = {
	101: 38,
}

# must be length 8
var quick_select: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1]
var equipped_melee: int = 401
var equipped_gun: int = 101

# 0 = melee
# 1 = gun
# defaults to melee
var active_item: int = 0

@onready var _player_hud = get_node("../HUD/PlayerHUD")

# Called when the node enters the scene tree for the first time.
func _ready():
	# load inventory items perhaps?
	print(get_collected_item_ids())
	pass # Replace with function body.

func load_item(id: int):
	var equipped_item_node = get_node("../Pivot/EquippedItem")
	var item = load(ItemManager.item_resource_path % ItemManager.item_assignments[id]).instantiate()
	var currently_equipped_item = equipped_item_node.get_child(0)
	if not currently_equipped_item == null:
		equipped_item_node.remove_child(currently_equipped_item)
	equipped_item_node.add_child(item)
	if id > 99 and id < 200: # item is a gun
		_player_hud.setup_gun(item.max_ammo, item.icon)

func load_melee():
	_player_hud.hide_ammo_counter()
	load_item(equipped_melee)

func load_gun():
	load_item(equipped_gun)
	_player_hud.set_ammo_counter(gun_ammo_count[equipped_gun])

func collect_item(id: int):
	items[id] = true

# returns whether the gun may shoot
func shoot_gun(id: int) -> bool:
	if gun_ammo_count[id] == 0:
		return false
	gun_ammo_count[id] -= 1
	# update UI
	_player_hud.set_ammo_counter(gun_ammo_count[id])
	return true

func get_collected_item_ids() -> Array[int]:
	var result: Array[int] = []
	for i in items.keys():
		if items[i] == true:
			result.append(i)
	return result
