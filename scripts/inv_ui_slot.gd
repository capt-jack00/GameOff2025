extends Panel

@onready var itemvisual : Sprite2D = $CenterContainer/Panel/ItemDisplay

#TODO: Review and document code below
func update(item: InvItem):
	if !item:
		itemvisual.visible = false
	else:
		itemvisual.visible = true
		itemvisual.texture = item.texture 	
	
