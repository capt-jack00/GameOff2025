extends Resource

class_name InvItem

#Nothing special here, just implementing the two values for the item. In this
# case we use only name and texture, but we can add more like id or item_type.
# Example: @export var type: String = ""
@export var name: String = ""
@export var texture: Texture2D
