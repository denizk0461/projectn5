extends HBoxContainer

@onready var _item_preview_viewport
@onready var _item_slots: Array[TextureButton]

#@onready var _inventory: Node3D

signal equip_weapon_from_weapons_menu(id: int)

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
		print(_item_slots[i].get_node("Slot"))
		_item_slots[i].get_node("Slot").texture = load(ItemManager.get_icon_path(_item_slot_ids[i]))
	
	_item_preview_viewport.display_item(102) # display current item here

func select_item(id):
#	if  == id:
#		return
	# send to inventory to equip this item
	_item_preview_viewport.display_item(id)
	equip_weapon_from_weapons_menu.emit(id)

func _on_slot_0_pressed():
	select_item(_item_slot_ids[0])

func _on_slot_1_pressed():
	select_item(_item_slot_ids[1])

func _on_slot_2_pressed():
	select_item(_item_slot_ids[2])

func _on_slot_3_pressed():
	select_item(_item_slot_ids[3])

func _on_slot_4_pressed():
	select_item(_item_slot_ids[4])

func _on_slot_5_pressed():
	select_item(_item_slot_ids[5])

func _on_slot_6_pressed():
	select_item(_item_slot_ids[6])

func _on_slot_7_pressed():
	select_item(_item_slot_ids[7])

func _on_slot_8_pressed():
	select_item(_item_slot_ids[8])

func _on_slot_9_pressed():
	select_item(_item_slot_ids[9])

func _on_slot_10_pressed():
	select_item(_item_slot_ids[10])

func _on_slot_11_pressed():
	select_item(_item_slot_ids[11])
