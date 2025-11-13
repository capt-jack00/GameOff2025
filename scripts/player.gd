extends CharacterBody2D

var speed = 5
@export var attack_damage := 10
var criticalStrikeChance := 5	# this value is % for a critical strike

func rotate_sword_hitbox():
	if !$attack_hitbox.monitoring:		#Makes sure player can't rotate hitbox while attacking	
		$attack_hitbox.rotation = PI / 2 - atan(Global.mousePosAroundCenterOfScreen.x / Global.mousePosAroundCenterOfScreen.y)
# equastion above works by calculating how far away from center of screen is mouse position and then
# doing reverse of trygonometric function(tdwan) to get angle at which should box be rotated
# '-' is here because it was rotating in wrong directionsd
# PI / 2 is here because it was displaced (PI / 2 is 90 degrees in radians) so it just got rotated right by
# 90 degrees
# when you use tan on angle you get ratio of square triangle legs. Here is exactly the same process but
# in reverssd.
		var offset = 0
		if Global.mousePosAroundCenterOfScreen.y <= 0:	#set offset based on where the mouse is
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
		
	input_vector = input_vector.normalized()
	velocity = input_vector * speed * 50	#idk why but move_and_slide is a lot slower than move_and_collide and because of that I needed to multiply this value by 50
	move_and_slide()	#Moves player and doesn't block him on wall
	
	# --- ATTACK ---
	handle_attack()
	rotate_sword_hitbox()
		
		
	#	==================	Animation handling	=========================
	if $AnimationPlayer.current_animation != "p_attack":	# makes sure that attack doesn't get overwritten
		if input_vector == Vector2.ZERO:		# checks if player doesn't move
			$AnimationPlayer.play("soldier_idle")
		else:
			$AnimationPlayer.play("soldier_walk")

func handle_attack():
	if Input.is_action_just_pressed("left_mb") && !$attack_hitbox.monitoring && !$InvUI.mouseOnInventory():
		$AnimationPlayer.play("p_attack")			#play animation of player attacking
		$attack_hitbox/shape/StrikeSprite.visible = true		#makes strike sprite visible (sprite in front of player)
		$attack_hitbox/shape/AnimationPlayer.play("strike")		#plays animation of strike
		 
		await get_tree().create_timer(0.001).timeout	#without when player was spamming attack he could block hitbox changing direction
		$attack_hitbox.monitoring = true				#turns hitbox on
		await $AnimationPlayer.animation_finished		#waits until p_attack finishes
		$attack_hitbox.monitoring = false				#turns hitbox off
		
		$attack_hitbox/shape/StrikeSprite.visible = false
		print("Attack!")

func _on_attack_hitbox_area_entered(area: Area2D) -> void:		#chesdcks if sword hit box is inside another thing hurtbox
	if area.is_in_group("hurtbox"):
		area.get_parent().take_damage(attack_damage, criticalStrikeChance)
