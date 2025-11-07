extends CharacterBody2D

var speed = 2
@export var attack_damage := 10

#TODO: 

func update_attack_hitbox(direction):		#updates sword hitbox based on player rotation
	var offset = 16
	$attack_hitbox.position.x = 0			#return to basic value so the hitbox doesn't go away
	$attack_hitbox.position.x += offset * direction
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):	#D
		input_vector.x += 1
		$Sprite2D.flip_h = false
		
	if Input.is_action_pressed("move_left"):	#A
		input_vector.x -= 1
		$Sprite2D.flip_h = true
		
	if Input.is_action_pressed("move_down"):	#S
		input_vector.y += 1
		
	if Input.is_action_pressed("move_up"):		#W
		input_vector.y -= 1
	
	
	# --- ATTACK ---
	if input_vector.x != 0.0:		#check for 0 is needed so later it doesn't multiply by 0
		update_attack_hitbox(input_vector.x)	#updates sword hitbox based on player rotation
		
	if Input.is_action_just_pressed("left_mb"):
		$attack_hitbox.monitoring = true
		$AnimationPlayer.play("p_attack")
		await $AnimationPlayer.animation_finished
		$attack_hitbox.monitoring = false
		print("Attack!")
		
	#	==================	Animation handling	=========================
	if !$AnimationPlayer.current_animation == "p_attack":	
		if input_vector == Vector2.ZERO:
			$AnimationPlayer.play("soldier_idle")
		else:
			$AnimationPlayer.play("soldier_walk")


	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_collide(velocity)
	

func _on_attack_hitbox_area_entered(area: Area2D) -> void:		#checks if sword hit box is inside another thing hurtbox
	if area.is_in_group("hurtbox"):
		area.get_parent().take_damage(attack_damage)
