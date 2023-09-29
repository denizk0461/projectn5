extends Control

var _ammo_template: String = "[b]%s[/b] /%s"

func set_ammo_counter(current_ammo: int, max_ammo: int):
	show_ammo_counter()
	$AmmoPanel/CountLabel.bbcode_text = _ammo_template % [current_ammo, max_ammo]

func show_ammo_counter():
	$AmmoPanel.show()

func hide_ammo_counter():
	$AmmoPanel.hide()
