extends CharacterBody2D

var speed = 5
@export var attack_damage := 10

@export var inv: Inv

func rotate_sword_hitbox():
	var mousePos = get_viewport().get_mouse_position()
	var windowSize = get_viewport().get_visible_rect().size
	var mousePosAroundCenterOfScreen = windowSize / 2 - mousePos
	$attack_hitbox.rotation = PI / 2 - atan(mousePosAroundCenterOfScreen.x / mousePosAroundCenterOfScreen.y)
	# equastion above works by calculating how far away from center of screen is mouse position and then
	# doing reverse of trygonometric function(tan) to get angle at which should box be rotated
	# '-' is here because it was rotating in wrong directionsd
	# PI / 2 is here because it was displaced (PI / 2 is 90 degrees in radians) so it just got rotated right by
	# 90 degrees
	# when you use tan on angle you get ratio of square triangle legs. Here is exactly the same process but
	# in reverse.
	var offset = 0
	if mousePosAroundCenterOfScreen.y >= 0:	#set offset based on where the mouse is
		$attack_hitbox/shape/StrikeSprite.flip_h = true
		$attack_hitbox/shape/StrikeSprite.flip_v = true
		offset = -25
	else:
		$attack_hitbox/shape/StrikeSprite.flip_h = false
		$attack_hitbox/shape/StrikeSprite.flip_v = false
		offset = 25
	$attack_hitbox/shape.position.x = 0 
	$attack_hitbox/shape.position.x += offset	
	
func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):	#D
		input_vector.x += 1
		$PlayerModelSprite.flip_h = false
		
	if Input.is_action_pressed("move_left"):	#s
		input_vector.x -= 1
		$PlayerModelSprite.flip_h = true
		
	if Input.is_action_pressed("move_down"):	#S
		input_vector.y += 1
		
	if Input.is_action_pressed("move_up"):		#W
		input_vector.y -= 1
	
	
	# --- ATTACK ---
	rotate_sword_hitbox()
		
	if Input.is_action_just_pressed("left_mb") && !$attack_hitbox.monitoring:
		$AnimationPlayer.play("p_attack")			#play animation of player attacking
		$attack_hitbox/shape/StrikeSprite.visible = true		#makes strike sprite visible (sprite in front of player)
		$attack_hitbox/shape/AnimationPlayer.play("strike")		#plays animation of strike
		$attack_hitbox.monitoring = true
		await $AnimationPlayer.animation_finished	
		$attack_hitbox.monitoring = false
		$attack_hitbox/shape/StrikeSprite.visible = false
		print("Attack!")
		
	#	==================	Animation handling	=========================
	if $AnimationPlayer.current_animation != "p_attack":	# makes sure that attack doesn't get overwritten
		if input_vector == Vector2.ZERO:		# checks if player doesn't move
			$AnimationPlayer.play("soldier_idle")
		else:
			$AnimationPlayer.play("soldier_walk")

	input_vector = input_vector.normalized()
	velocity = input_vector * speed * 50	#idk why but move_and_slide is a lot slower than move_and_collide and because of that I needed to multiply this value by 50
	move_and_slide()	#Moves player and doesn't block him on wall
	

func _on_attack_hitbox_area_entered(area: Area2D) -> void:		#checks if sword hit box is inside another thing hurtbox
	if area.is_in_group("hurtbox"):
		area.get_parent().take_damage(attack_damage)
