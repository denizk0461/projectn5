extends HBoxContainer

@onready var _item_preview_viewport
@onready var _item_slots: Array[TextureButton]

#@onready var _inventory: Node3D

signal equip_weapon_from_weapons_menu(id: int)

var _base_slot_texture_normal = ImageTexture.create_from_image(load("res://Art/items/other/menu/menu_item_slot_normal.png").get_image())
var _base_slot_texture_hovered = ImageTexture.create_from_image(load("res://Art/items/other/menu/menu_item_slot_hovered.png").get_image())
var _selected_slot_texture_normal = ImageTexture.create_from_image(load("res://Art/items/other/menu/menu_item_slot_selected.png").get_image())
var _selected_slot_texture_hovered = ImageTexture.create_from_image(load("res://Art/items/other/menu/menu_item_slot_selected_hovered.png").get_image())

var _currently_clicked_item: int

# items displayed in the item slots, in order
var _item_slot_ids = [
	102, 101, 101,
	101, 102, 102,
	102, 101, 101,
	101, 102, 101
]

func _ready():
	_item_preview_viewport = $VBoxContainer/ItemPreviewContainer/ItemPreview
	_item_slots = [
		$WeaponsGrid/WeaponsRow0/Slot0,
		$WeaponsGrid/WeaponsRow0/Slot1,
		$WeaponsGrid/WeaponsRow0/Slot2,
		
		$WeaponsGrid/WeaponsRow1/Slot3,
		$WeaponsGrid/WeaponsRow1/Slot4,
		$WeaponsGrid/WeaponsRow1/Slot5,
		
		$WeaponsGrid/WeaponsRow2/Slot6,
		$WeaponsGrid/WeaponsRow2/Slot7,
		$WeaponsGrid/WeaponsRow2/Slot8,
		
		$WeaponsGrid/WeaponsRow3/Slot9,
		$WeaponsGrid/WeaponsRow3/Slot10,
		$WeaponsGrid/WeaponsRow3/Slot11
	]
	
	for i in _item_slots.size():
		_item_slots[i].get_node("Slot").texture = load(ItemManager.get_icon_path(_item_slot_ids[i]))

func show_and_focus():
	show()
	_highlight_equipped_item_on_ready()

func _highlight_equipped_item_on_ready():
	# this is jank but works
	var id = get_node("../../../Inventory").equipped_gun
	_currently_clicked_item = id
	_item_preview_viewport.display_item(id)
	
	for i in _item_slots.size():
		if _item_slot_ids[i] == id:
			_item_slots[i].grab_focus()
			_highlight_slot(i)
			return

func _select_item(index):
	var id = _item_slot_ids[index]
	# check if the item has been pressed repeatedly
	if _currently_clicked_item == id:
		return
	
	_currently_clicked_item = id
	_item_preview_viewport.display_item(id)
	equip_weapon_from_weapons_menu.emit(id)
	_highlight_slot(index)

func _set_slot_textures(slot, is_selected):
	if is_selected:
		slot.texture_normal = _selected_slot_texture_normal
		slot.texture_hover = _selected_slot_texture_hovered
		slot.texture_focused = _selected_slot_texture_hovered
	else:
		slot.texture_normal = _base_slot_texture_normal
		slot.texture_hover = _base_slot_texture_hovered
		slot.texture_focused = _base_slot_texture_hovered

func _highlight_slot(index):
	for i in _item_slots.size():
		if i == index:
			_set_slot_textures(_item_slots[i], true)
		else:
			_set_slot_textures(_item_slots[i], false)

func _on_slot_0_pressed():
	_select_item(0)

func _on_slot_1_pressed():
	_select_item(1)

func _on_slot_2_pressed():
	_select_item(2)

func _on_slot_3_pressed():
	_select_item(3)

func _on_slot_4_pressed():
	_select_item(4)

func _on_slot_5_pressed():
	_select_item(5)

func _on_slot_6_pressed():
	_select_item(6)

func _on_slot_7_pressed():
	_select_item(7)

func _on_slot_8_pressed():
	_select_item(8)

func _on_slot_9_pressed():
	_select_item(9)

func _on_slot_10_pressed():
	_select_item(10)

func _on_slot_11_pressed():
	_select_item(11)
