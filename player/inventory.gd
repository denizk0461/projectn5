extends Node3D

var items: Dictionary = {
	101: {
		"collected": true,
		"version": 1,
		"current_ammo": 40,
	},
	199: {
		"collected": true,
		"version": 1,
		"current_ammo": 40,
	},
	#401: true, # hm
}

# must be length 8
var quick_select: Array[int] = [101,199,101,101,199,101,101,-1]
var equipped_melee: int = 401
var equipped_gun_id: int = 101 if quick_select[0] == 0 else quick_select[0]
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
	var equipped_item_node = get_node("../Pivot/Character/BoneAttachment3D/EquippedItem")
	var item = load(ItemManager.get_scene_path(id, 1)).instantiate()
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
	_load_item(equipped_gun_id)
	_set_ammo_counter(equipped_gun_id)
	
func _set_ammo_counter(weapon_id):
	_player_hud.set_ammo_counter(items[equipped_gun_id]["current_ammo"])

func _load_gadget():
	_load_item(equipped_gun_id)

func collect_item(id: int):
	items[id] = true

# returns whether the gun may shoot
func shoot_gun(id: int) -> bool:
	if items[id]["current_ammo"] == 0:
		return false
	items[id]["current_ammo"] -= 1
	# update UI
	_player_hud.set_ammo_counter(items[id]["current_ammo"])
	return true

func get_collected_item_ids() -> Array[int]:
	var result: Array[int] = []
	for i in items.keys():
		if items[i] == true:
			result.append(i)
	return result

func _on_item_equipped(item_id: int):
	if item_id >= 100 and item_id <= 199: # gun
		equipped_gun_id = item_id
		is_melee_equipped = false
		_load_gun()
	elif item_id >= 200 and item_id <= 299: # gadget
		equipped_gun_id = item_id
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

func reload_gun(weapon_id) -> Dictionary:
	var refill = ItemManager.get_item_attribute(weapon_id, items[weapon_id]["version"], ItemManager.ATTR_AMMO_REFILL)
	var max_ammo = ItemManager.get_item_attribute(weapon_id, items[weapon_id]["version"], ItemManager.ATTR_MAX_AMMO)
	var current_ammo = items[weapon_id]["current_ammo"]
	var refill_amount: int
	if current_ammo >= max_ammo:
		return {
			"has_collected": false,
			"refill_amount": 0,
		}
	
	if current_ammo <= max_ammo - refill:
		refill_amount = refill
	else:
		refill_amount = max_ammo - current_ammo
	
	items[weapon_id]["current_ammo"] += refill_amount
	_set_ammo_counter(weapon_id)
	return {
		"has_collected": true,
		"refill_amount": refill_amount,
	} 
