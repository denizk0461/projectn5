extends Node

# TODO convert this from a JSON-type structure to a separate data structure?
# what would be the best way to do that?
var _weapon_data_lookup_table = {
	"101": { # N5 Blaster
		"type": "weapon",
		"v1": {
			"name": "ITEM_101_NAME_V1",
			"description": "ITEM_101_DESC_V1",
			"damage": 999,
			"max_ammo": 60,
			"ammo_refill": 12,
			"price": 0
		},
		"v2": {
			"name": "ITEM_101_NAME_V2",
			"description": "ITEM_101_DESC_V2",
			"damage": 999,
			"max_ammo": 120,
			"ammo_refill": 24,
			"price": 10000
		},
		"v3": {
			"name": "ITEM_101_NAME_V3",
			"description": "ITEM_101_DESC_V3",
			"damage": 999,
			"max_ammo": 200,
			"ammo_refill": 40,
			"price": 50000
		},
	},
	"199": { # Purple Gun
		"type": "weapon",
		"v1": {
			"name": "Purple Gun V1",
			"description": "This is the overly long description for the base level Purple Gun. Why is this overly long? Because I need to test whether long texts scroll properly in the Weapons menu. Yup. That's the only reason. Enjoy the rest of this text: America is a nation that can be defined in a single word: ASUFUTIMAEHAEHFUTBW.",
			"damage": 999,
			"max_ammo": 60,
			"ammo_refill": 12,
			"price": 1
		},
		"v2": {
			"name": "Purple Gun V2",
			"description": "Second upgrade Purple Gun!",
			"damage": 999,
			"max_ammo": 120,
			"ammo_refill": 24,
			"price": 2
		},
		"v3": {
			"name": "Purple Gun V★",
			"description": "This is the final version of the Purple Gun.",
			"damage": 999,
			"max_ammo": 200,
			"ammo_refill": 40,
			"price": 3
		},
	},
}

var ATTR_NAME: String = "name"
var ATTR_DESCRIPTION: String = "description"
var ATTR_DAMAGE: String = "damage"
var ATTR_MAX_AMMO: String = "max_ammo"
var ATTR_AMMO_REFILL: String = "ammo_refill"
var ATTR_PRICE: String = "price"

var _ITEM_PATH: String = "res://items/equippables"

func get_item_attribute(id: int, version: int, attribute: String):
	return _weapon_data_lookup_table["%d" % id]["v%d" % version][attribute]

func get_icon_path(id) -> String:
	return "%s/%d/icon.webp" % [_ITEM_PATH, id]

func get_scene_path(id, version) -> String:
	return "%s/%d/v%d/item.tscn" % [_ITEM_PATH, id, version]

func get_projectile_path(id, version) -> String:
	return "%s/%d/v%d/projectile.tscn" % [_ITEM_PATH, id, version]
