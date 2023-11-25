extends Node3D

var items: Dictionary = {
	101: true,
	102: true,
	401: true,
}

var gun_ammo_count: Dictionary = {
	101: 40,
	102: 60,
}

# must be length 8
var quick_select: Array[int] = [102,101,102,102,101,102,102,101]
var equipped_melee: int = 401
var equipped_gun: int = quick_select[0] if quick_select[0] == 0 else 102
var is_melee_equipped: bool = true # false if gun/gadget

# 0 = melee
# 1 = gun
# defaults to melee
var active_item: int = 0

@onready var _player_hud = get_node("../HUD/PlayerHUD")

# Called when the node enters the scene tree for the first time.
func _ready():
	# load inventory items perhaps?
	pass

func _load_item(id: int):
	var equipped_item_node = get_node("../Pivot/EquippedItem")
	var item = load(ItemManager.get_scene_path(id)).instantiate()
	var currently_equipped_item = equipped_item_node.get_child(0)
	if not currently_equipped_item == null:
		equipped_item_node.remove_child(currently_equipped_item)
	equipped_item_node.add_child(item)
	if id >= 100 and id <= 199: # item is a gun
		_player_hud.setup_gun(item.max_ammo, item.icon)

func _load_melee():
	_player_hud.hide_ammo_counter()
	_load_item(equipped_melee)

func _load_gun():
	_load_item(equipped_gun)
	_player_hud.set_ammo_counter(gun_ammo_count[equipped_gun])

func _load_gadget():
	_load_item(equipped_gun)

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

func _on_item_equipped(item_id: int):
	if item_id >= 100 and item_id <= 199: # gun
		equipped_gun = item_id
		is_melee_equipped = false
		_load_gun()
	elif item_id >= 200 and item_id <= 299: # gadget
		equipped_gun = item_id
		is_melee_equipped = false
		_load_gadget()
	elif item_id >= 400 and item_id <= 499: # melee
		equipped_melee = item_id
		is_melee_equipped = true
		_load_melee()

func switch_to_melee():
	is_melee_equipped = true
	_load_melee()

func switch_to_gun():
	is_melee_equipped = false
	_load_gun()

func _on_quick_select_item_equipped(item_id):
	_on_item_equipped(item_id)

func _on_equip_weapon_from_menu(id):
	_on_item_equipped(id)
