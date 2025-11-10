extends CharacterBody2D
var health = 300
var isAlive = true
var alreadyTakenDamage = false	#flag to prevent player from dealing damage 2 times to an object in single attack
var hitCritically = false
var speed = 0.5
@onready var target = get_tree().get_first_node_in_group("player")

# QUICKNOTE: We can't really use collision for enemies because when collision is applied then
# if enemy collides with the player from the top, it sticks to it because Godot thinks that 
# the top of the player is floor. In this case how we can fix that is to applay similar mechanism 
# like in terraria. There is no player-enemy collision but when player is getting hit it just throws 
# him back away making an illusion of the collison

var font = load("res://Fonts/test.ttf")		#load font from file

func _physics_process(_delta):
	if target.get_node("attack_hitbox").monitoring == false:	#check if player finished attack
		alreadyTakenDamage = false
	
	if is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		position += velocity	#moves barrel
		if move_and_collide(velocity, true):	#checks only if collision between barrel and player occured
			position -= velocity		#without it barrel will move player
		
		
func take_damage(attack_damage, criticalStrikeChance):
	if isAlive && !alreadyTakenDamage:
		if randi() % 100 < criticalStrikeChance:
			attack_damage *= 2
			hitCritically = true
		else:
			hitCritically = false
		
		health -= attack_damage
		print("Enemy took", attack_damage, "damage! Remaining:", health)
		alreadyTakenDamage = true
		
		handle_hitIndicator(attack_damage, hitCritically)
	else:
		return
	
	if health <= 0:
		isAlive = false
		queue_free() # deletes the node from the existence 
		# remember this method because it's very helpful and handy to handle the death method
		
		
func handle_hitIndicator(damage, hitCritically):
	var hitIndicator = Label.new()		#Create hit indicator
	$CenterContainer.add_child(hitIndicator)	#add it as child to another control node so later it can be positioned
	
	#	======================	 font	======================
	hitIndicator.add_theme_font_override("font", font)		#set custom font
	hitIndicator.add_theme_font_size_override("font_size", 25)	#set font size
	if !hitCritically:
		hitIndicator.add_theme_color_override("font_color", Color(0.737, 0.502, 0.3, 1.0))	# set font color
	else:
		hitIndicator.add_theme_color_override("font_color", Color(0.67, 0.249, 0.174, 1.0))	# set font color
	
	#	======================	 Font border	======================
	hitIndicator.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))	# set border color
	hitIndicator.add_theme_constant_override("outline_size", 5)		#set border size
	
	var maxoffset = 15
	var offset = Vector2(-maxoffset + randi() % maxoffset * 2, -maxoffset + randi() % maxoffset * 2)	# offset from -15 to 15
	var rotationOffset = -0.5 + randf()
	$CenterContainer.position = Vector2(-20, -20)	#return to center
	$CenterContainer.position += offset		#add offset
	$CenterContainer.rotation = rotationOffset	
	
	hitIndicator.text = str(-damage)		#set value of hitindicator
	
	await get_tree().create_timer(1.0).timeout		#delete old hit indicator after 1 second
	hitIndicator.queue_free()
