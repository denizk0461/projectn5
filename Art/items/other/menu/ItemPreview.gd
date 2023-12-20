extends SubViewport

var _item_rotation_speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MenuItem/ItemSpot.rotation_degrees += Vector3(0.0, _item_rotation_speed * delta, 0.0)

func display_item(id):
	$MenuItem/ItemSpot.rotation_degrees = Vector3.ZERO
	var currently_displayed_item = $MenuItem/ItemSpot.get_child(0)
	if not currently_displayed_item == null:
		$MenuItem/ItemSpot.remove_child(currently_displayed_item)
	var item = load(ItemManager.get_scene_path(id, 1)).instantiate()
	item.get_node("model").position = Vector3.ZERO
	$MenuItem/ItemSpot.add_child(item)
	# reset rotation
