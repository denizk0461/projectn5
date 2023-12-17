extends Node

var item_assignments: Dictionary = {
	# 1xx == guns
	101: "weapons/purplegun",
	102: "weapons/n5blaster",
	# 2xx == gadgets
	# 3xx == items
	# 4xx == melee weapons
	401: "melee/inanimatecarbonrod",
	# 6xx == ammunition
#	601: "Ammo/PurpleGunAmmo",
}

var _weapon_data_lookup_table = {
	"101": {
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
	"102": {
		"type": "weapon",
		"v1": {
			"name": "WEAPON_102_NAME_V1",
			"description": "WEAPON_102_DESC_V1",
			"damage": 999,
			"max_ammo": 60,
			"ammo_refill": 12,
			"price": 0
		},
		"v2": {
			"name": "WEAPON_102_NAME_V2",
			"description": "WEAPON_102_DESC_V2",
			"damage": 999,
			"max_ammo": 120,
			"ammo_refill": 24,
			"price": 10000
		},
		"v3": {
			"name": "WEAPON_102_NAME_V3",
			"description": "WEAPON_102_DESC_V3",
			"damage": 999,
			"max_ammo": 200,
			"ammo_refill": 40,
			"price": 50000
		},
	},
}

var item_resource_path: String = "res://Items/%s.tscn"
var item_icon_path: String = "res://Items/%s.png"
var projectile_path: String = "res://Items/Weapons/Projectiles/%s.tscn"

var ATTR_NAME: String = "name"
var ATTR_DESCRIPTION: String = "description"
var ATTR_DAMAGE: String = "damage"
var ATTR_MAX_AMMO: String = "max_ammo"
var ATTR_AMMO_REFILL: String = "ammo_refill"
var ATTR_PRICE: String = "price"

func get_item_attribute(id: int, version: int, attribute: String):
	return _weapon_data_lookup_table["%d" % id]["v%d" % version][attribute]

func get_icon_path(id) -> String:
	return "res://Art/items/%s/icon.png" % item_assignments[id]

func get_scene_path(id) -> String:
	return "res://Art/items/%s/model.tscn" % item_assignments[id]

func get_projectile_path(id) -> String:
	return "res://Art/items/%s/projectile.tscn" % item_assignments[id]
