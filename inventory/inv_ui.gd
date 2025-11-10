extends Control

var is_open = false
@onready var inv: Inv = preload("res://inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

# When everything is loaded update the slots and close the inventory so the 
#game won't start with open inventory
func _ready():
	updateSlots()
	close()

# TODO: Review and document the code below
func updateSlots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta):
	#This function allows us to close/open the inventory dependent
	# on it's state closed/opened
	if Input.is_action_just_pressed("open_inv"): #TAB 
		if is_open: #If inventory is open close it
			close() 
		else:
			open()

# I think that explaining below code is pointless
func close():
	visible = false
	is_open = false
	
func open():
	visible = true
	is_open = true 
