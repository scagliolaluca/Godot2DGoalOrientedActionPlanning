extends StaticBody2D

@export var nutrition = 30

#regrow process of mushroom (if mushroom gets collected, it needs 40 seconds to regrow)
func regrow():
	self.visible = false
	await get_tree().create_timer(40).timeout
	self.visible = true
