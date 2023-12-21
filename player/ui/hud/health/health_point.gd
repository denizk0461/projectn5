extends Control

func set_active(is_active):
	if is_active:
		$HealthPositive.show()
		$HealthNegative.hide()
	else:
		$HealthPositive.hide()
		$HealthNegative.show()
