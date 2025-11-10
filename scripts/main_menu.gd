extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().change_scene_to_file("res://scenes/world.tscn") # skip main menu (usefull for debugging)
	#print_rich("[color=red]Menu was turned off in file main_menu.gd on line 6 to debug game easier[/color]")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# You're an idiot if you need this code to be explained
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
