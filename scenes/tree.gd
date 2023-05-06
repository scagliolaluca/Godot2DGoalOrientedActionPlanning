extends StaticBody2D


var _hp = 3


func chop():
	if not $chop_cooldown.is_stopped():
		return false

	_hp -= 1
	if _hp == 0:
		regrow()
		return true
	$chop_cooldown.start()
	return false

#regrow process of tree (if tree gets felled, it needs 90 seconds to regrow)
func regrow():
	self.visible = false
	await get_tree().create_timer(90).timeout
	_hp = 3
	self.visible = true
