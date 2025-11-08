extends CharacterBody2D
var health = 30
var isAlive = true
var alreadyTakenDamage = false	#flag to prevent player from dealing damage 2 times to an object in single attack
var speed = 10
@onready var target = get_tree().get_first_node_in_group("player")

# QUICKNOTE: We can't really use collision for enemies because when collision is applied then
# if enemy collides with the player from the top, it sticks to it because Godot thinks that 
# the top of the player is floor. In this case how we can fix that is to applay similar mechanism 
# like in terraria. There is no player-enemy collision but when player is getting hit it just throws 
# him back away making an illusion of the collison

func _physics_process(delta):
	if target.get_node("attack_hitbox").monitoring == false:	#check if player finished attack
		alreadyTakenDamage = false
	
	if is_instance_valid(target):
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

		
func take_damage(amount):
	if isAlive && !alreadyTakenDamage:
		health -= amount
		print("Enemy took", amount, "damage! Remaining:", health)
		alreadyTakenDamage = true
	else:
		return
	
	if health <= 0:
		isAlive = false
		queue_free() # deletes the node from the existence 
		# remember this method because it's very helpful and handy to handle the death method
