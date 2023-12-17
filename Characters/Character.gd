extends Node3D

@onready var animation = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	lower_arm()

func lower_arm():
	animation.set("parameters/HandPosition/blend_amount", 0)

func point():
	animation.set("parameters/HandPosition/blend_amount", 1)
