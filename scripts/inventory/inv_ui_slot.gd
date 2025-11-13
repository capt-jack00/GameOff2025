extends Panel

@onready var itemSprite: Sprite2D = $CenterContainer/Panel/ItemDisplay

#TODO: Review and document code below
func update(item: InvItem):
	if !item:
		itemSprite.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = item.texture 	
	
func _on_gui_input():
	if Input.is_action_just_pressed("left_mb"):
		return true
	return false
