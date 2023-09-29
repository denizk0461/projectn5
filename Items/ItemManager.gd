extends Node

var item_assignments: Dictionary = {
	# 1xx == guns
	101: "Weapons/PurpleGun",
	# 2xx == gadgets
	# 3xx == items
	# 4xx == melee weapons
	401: "Weapons/InanimateCarbonRod",
	# 6xx == ammunition
	601: "Ammo/PurpleGunAmmo",
}
var item_resource_path: String = "res://Items/%s.tscn"
var projectile_path: String = "res://Items/Weapons/Projectiles/%s.tscn"
