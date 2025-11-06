extends CharacterBody2D

var speed = 2
@export var attack_damage := 10

#TODO: Sword hitbox doesn't change directions when player walking does. Fix that.

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "p_attack":
		move_and_collide(Vector2.ZERO)
		return

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
		$Sprite2D.flip_h = false
		$AnimationPlayer.play("soldier_walk")
		
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
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
	
	# --- ATTACK ---
	if Input.is_action_just_pressed("left_mb"):
		$AnimationPlayer.play("p_attack")
		print("Attack!")

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_collide(velocity)


func _on_p_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.get_parent().take_damage(attack_damage)
