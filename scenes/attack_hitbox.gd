extends Area2D

var thread: Thread

func _ready() -> void:
	thread = Thread.new()
	thread.start(_thread_function.bind())
	
func _thread_function():
		$attack_hitbox.monitoring = true
		$AnimationPlayer.play("p_attack")
		await $AnimationPlayer.animation_finished
		$attack_hitbox.monitoring = false
		print("Attack!")
	
func _exit_tree():
	thread.wait_to_finish()
