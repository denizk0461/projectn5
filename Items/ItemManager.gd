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

var _weapon_data_lookup_table = null # TODO

var item_resource_path: String = "res://Items/%s.tscn"
var item_icon_path: String = "res://Items/%s.png"
var projectile_path: String = "res://Items/Weapons/Projectiles/%s.tscn"

func get_icon_path(id) -> String:
	return "res://Art/items/%s/icon.png" % item_assignments[id]

func get_scene_path(id) -> String:
	return "res://Art/items/%s/model.tscn" % item_assignments[id]

func get_projectile_path(id) -> String:
	return "res://Art/items/%s/projectile.tscn" % item_assignments[id]
