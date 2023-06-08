extends Area2D

var direction = Vector2.RIGHT
var speed: float = 500

func _process(delta):
	# Move the bullet
	translate(direction * speed * delta)


func _on_body_entered(body):
	if body.object_type == "Enemy":
		# Reduce the enemy's health points
		body.health -= 50
		# Delete bullet
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Delete bullet
	queue_free()
