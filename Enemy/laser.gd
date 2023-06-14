extends RayCast2D

@onready var laser: Line2D = $Laser
@onready var laser_end: Node2D = $LaserEnd

var max_distance: float = 400

func _ready():
	# Set the maximum cast distance of the raycast
	target_position = Vector2(max_distance, 0)
	# Set the default colour of the laser
	var laser_colour = Color(7.11, 1.18, 1.18, 1)
	laser.set_modulate(laser_colour)

func _physics_process(delta):
	# Check if the laser is colliding with the player or a world object
	if is_colliding():
		# Get the point of collision in global coordinates then cast to local coordinates
		var collision_point: Vector2 = to_local(get_collision_point())
		# Update the laser's end point and sparks to the current collision point
		laser.points[1].x = collision_point.x
		laser_end.position.x = collision_point.x - 15
	else:
		# Reset to the initial position
		laser.points[1].x = max_distance
		laser_end.position.x = max_distance - 15
