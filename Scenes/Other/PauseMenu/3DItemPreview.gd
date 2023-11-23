extends SubViewport

var _item_rotation_speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MenuItem.rotation_degrees += _item_rotation_speed * delta

func display_item(id):
	$MenuItem.rotation_degrees = 0
	var currently_displayed_item = $MenuItem/ItemSpot.get_child(0)
	if not currently_displayed_item == null:
		$MenuItem/ItemSpot.remove_child(currently_displayed_item)
	var item = load(ItemManager.get_scene_path(id)).instantiate()
	$MenuItem/ItemSpot.add_child(item)
	# reset rotation
