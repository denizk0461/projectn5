extends Area3D

var _colliding_with_player: bool = false
var _attack_animation_playing: bool = false
var _colliding_body: Node3D

func _process(delta):
	if _colliding_with_player and not _attack_animation_playing and not _colliding_body == null:
		_attack(_colliding_body)

func _attack(body):
	body.take_damage()
	get_parent().get_node("AnimationPlayer").play("Attack")
	_attack_animation_playing = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		_colliding_body = body
		_colliding_with_player = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		_colliding_body = null
		_colliding_with_player = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		_attack_animation_playing = false
