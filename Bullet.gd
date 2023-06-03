extends Area2D

var direction = Vector2.RIGHT
var speed: float = 400

func _process(delta):
	# Move the bullet
	translate(direction.normalized() * speed * delta)


func _on_body_entered(body):
	# Damage the body
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Delete bullet
	queue_free()
