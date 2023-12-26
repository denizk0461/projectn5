extends Node3D

@onready var animation = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	lower_arm()

func lower_arm():
	animation.set("parameters/HandPosition/blend_amount", 0)

func point():
	animation.set("parameters/HandPosition/blend_amount", 1)

func walk():
	animation.set("parameters/LegMovement/blend_amount", 1)

func stand_still():
	animation.set("parameters/LegMovement/blend_amount", 0)

func first_jump():
	#animation.set("parameters/FirstJump/active", true)
	animation.set("parameters/FirstJump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func second_jump():
	#animation.set("parameters/SecondJump/active", true)
	animation.set("parameters/SecondJump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
