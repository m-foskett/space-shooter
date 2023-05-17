extends CharacterBody2D

# Export variables for Player Physics
@export var MAX_SPEED: float = 500
@export var ACCELERATION: float = 1500
@export var FRICTION: float = 1200
# Player Input Axis
@onready var axis: Vector2 = Vector2.ZERO

func _physics_process(delta):
	move(delta)

func get_input_axis():
	# Map the input to a 2D Vector
	axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return axis.normalized() as Vector2

func move(delta):
	# Get the Input Axis
	axis = get_input_axis()
	# If there is no input
	if axis == Vector2.ZERO:
		# Apply friction/deceleration
		apply_friction(FRICTION * delta)
	# Else if there is input
	else:
		# Accelerate the player in the direction of the input axis vector
		apply_movement(axis * ACCELERATION * delta)
	# Move player based on velocity
	move_and_slide()

func apply_friction(amount: float):
	# If velocity length is greater than the friction value
	if velocity.length() > amount:
		# Decelerate based on friction value
		velocity -= velocity.normalized() * amount
	# Else if it is less than the friction value
	else:
		# Set velocity to zero
		velocity = Vector2.ZERO

func apply_movement(acceleration: Vector2):
	# Accelerate the player in the direction of the input axis vector
	velocity += acceleration
	# Apply a maximum limit to the velocity
	velocity = velocity.limit_length(MAX_SPEED)
