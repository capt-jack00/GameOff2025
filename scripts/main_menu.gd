extends Control

# You're an idiot if you need this code to be explained
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
