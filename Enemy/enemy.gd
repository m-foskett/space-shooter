extends CharacterBody2D

@export var movement_speed: float = 200.0

@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D
@export var health: float = 100
@export var object_type: String = "Enemy"

func _ready():
	# The distance threshold before a path point is considered to be reached
	navigation_agent.path_desired_distance = 4.0
	# The distance threshold before the final target point is considered to be reached
	navigation_agent.target_desired_distance = 4.0
	# Call the set movement target method on object in idle time
	call_deferred("actor_setup")

func actor_setup():
	# Wait for first frame of game for physics engine to sync up
	await get_tree().physics_frame
	# Set the movement target
	set_movement_target(movement_target.position)

func set_movement_target(target: Vector2):
	# Set the new target position to navigate towards
	navigation_agent.target_position = target

func _physics_process(_delta):
	# If navigation has finished then do nothing
	if navigation_agent.is_navigation_finished():
		return
	# Update target position to navigate towards
	set_movement_target(movement_target.position)
	# Get the global position of this node
	var current_agent_position: Vector2 = global_position
	# Get the next position in global coordinates that can be moved to
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	# Update the velocity of the node
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	velocity = new_velocity
	# Moves the body based on velocity
	move_and_slide()
	
func _process(_delta):
	# If no health remaining
	if health <= 0:
		# Delete self
		queue_free()
