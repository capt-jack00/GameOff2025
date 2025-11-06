extends StaticBody2D
var health = 30
var isAlive = true

func take_damage(amount):
	if isAlive:
		health -= amount
		print("Enemy took", amount, "damage! Remaining:", health)
	else:
		return
	
	if health <= 0:
		isAlive = false
		queue_free() # deletes the node from the existence 
		# remember this method because it's very helpful and handy to handle the death method
