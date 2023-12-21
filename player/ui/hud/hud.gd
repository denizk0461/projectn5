extends Control

var _ammo_template: String = "[b]%s[/b] /%s"
var _max_ammo: int

func set_ammo_counter(current_ammo: int):
	show_ammo_counter()
	$AmmoPanel/CountLabel.bbcode_text = _ammo_template % [current_ammo, _max_ammo]

func show_ammo_counter():
	$AmmoPanel.show()

func hide_ammo_counter():
	$AmmoPanel.hide()

func setup_gun(max_ammo: int, icon: CompressedTexture2D):
	self._max_ammo = max_ammo
	$AmmoPanel/Icon.texture = icon
