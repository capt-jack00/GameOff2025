extends CharacterBody2D
var health = 30
var isAlive = true

func take_damage(amount):
	if isAlive:
		health -= amount
		print("Enemy took", amount, "damage! Remaining:", health)
	else:
		return
	
	if health == 0:
		isAlive = false
		$BarrelSprite.visible = false
		$Area2D/BarrelCollision.disabled = true
