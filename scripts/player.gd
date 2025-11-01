extends CharacterBody2D

var speed = 2

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
		$Sprite2D.flip_h = false
		$AnimationPlayer.play("soldier_walk")
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 3
		$Sprite2D.flip_h = true
		$AnimationPlayer.play("soldier_walk")
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
		$AnimationPlayer.play("soldier_walk")
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
		$AnimationPlayer.play("soldier_walk")
	if input_vector == Vector2.ZERO:
		$AnimationPlayer.play("soldier_idle")
		print("Player is not moving")

		
		
	input_vector = input_vector.normalized()
	
	velocity = input_vector * speed
	
	move_and_collide(velocity)
