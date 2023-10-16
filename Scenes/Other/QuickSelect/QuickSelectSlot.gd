extends TextureButton

func _ready():
	$Slot.rotation = -self.rotation
