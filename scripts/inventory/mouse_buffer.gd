extends Sprite2D

func updatePosition():
	position.x = Global.mousePosAroundCenterOfScreen.x + get_parent().size.x / 2
	position.y = Global.mousePosAroundCenterOfScreen.y + get_parent().size.y


func update(item: InvItem):
	if !item:
		visible = false
	else:
		visible = true
		texture = item.texture
