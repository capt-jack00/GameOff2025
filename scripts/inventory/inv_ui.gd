extends Control

var is_open = false
@onready var inv: Inv = preload("res://inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var mouseBuffer = null

# When everything is loaded update the slots
func _ready():
	initialize_invenotory()

func initialize_invenotory():			# update all slots in inventory
	for i in inv.items.size():
		slots[i].update(inv.items[i])

func update_slot(index):		# to update just one slot
	slots[index].update(inv.items[index])

func _process(_delta):
	if is_open:
		$MouseBuffer.updatePosition()		# update item position rendered on mouse position
		handleItemMoving()					# handles item moving from slot to slot in inventory
	
	
	#This function allows us to close/open the inventory dependent
	# on it's state closed/opened
	if Input.is_action_just_pressed("open_inv"): #TAB 
		if is_open: #If inventory is open close it
			close() 
		else:
			open()

#	==========================	Handle Inventory openning/closing	==========================
func close():
	visible = false
	is_open = false		
	
func open():
	visible = true	
	is_open = true 
	
func handleItemMoving():
	for i in slots.size():
			var rect = Rect2(slots[i].position + position, slots[i].size)
			if rect.has_point(Global.mousePosAroundCenterOfScreen) && slots[i]._on_gui_input():		#checks if mouse is inside one of inventory slot
				# Switch item in slot with mouse buffer
				var temp = inv.items[i]
				inv.items[i] = mouseBuffer
				mouseBuffer = temp
				update_slot(i)				# update clicked slot
				$MouseBuffer.update(mouseBuffer)	#update mouse buffer
				

#	==========================	Check if mouse is inventory space	==========================
func mouseOnInventory():
	var rect = Rect2(position, size)	#creates rectangle from position and size of inventory
	if is_open && rect.has_point(Global.mousePosAroundCenterOfScreen):	#checks if mouse is in invenotory
		return true
	return false			
