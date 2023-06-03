extends CharacterBody2D

# Export variables for Player Physics
@export var MAX_SPEED: float = 500
@export var ACCELERATION: float = 1500
@export var FRICTION: float = 1200
# Player Input Axis
@onready var axis: Vector2 = Vector2.ZERO
# Interacted Areas Array
@onready var all_interactions: Array[Area2D] = []
@onready var interactLabel = $"Interaction Components/InteractLabel"

# Get the Bullet scene path
const path: String = "res://bullet.tscn"
# Preload instance of a Bullet scene
# Returns: a PackedScene from the filesystem located at path
var BulletScene: PackedScene = preload(path)

func _ready():
	# Update the interactions
	update_interactions()

func _physics_process(delta):
	move(delta)
	# If player is shooting
	if Input.is_action_just_pressed("ui_select"):
		fire_weapon()
	# If player is interacting
	if Input.is_action_just_pressed("Interact"):
		# Execute the interaction
		execute_interaction()
		
# Fire weapon
func fire_weapon():
	# Get the Bullet Node tree
	var bullet: Node = BulletScene.instantiate()
	# Assign a direction vector to the bullet spawn point
	bullet.direction =  $"Bullet Spawn Point".global_position - global_position
	# Set the bullet position to the bullet spawn point
	bullet.global_position = global_position
	# Add the bullet to the Scene tree
	add_child(bullet)

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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Interaction Methods
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_interaction_area_area_entered(area: Area2D):
	# Index to insert into
	var index: int = 0
	# Insert the interacted area into the array
	all_interactions.insert(index, area)
	# Update the interactions
	update_interactions()
	
func _on_interaction_area_area_exited(area: Area2D):
	# Remove the interacted area from the array
	all_interactions.erase(area)
	# Update the interactions
	update_interactions()
	
func update_interactions():
	# If there are interactions stored
	if all_interactions:
		# Update the display text
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""
		
func execute_interaction():
	# If there are interactions stored
	if all_interactions:
		# Get the current interaction
		var current_interaction: Area2D = all_interactions[0]
		# Match the current interaction's type
		match current_interaction.interact_type:
			"print_text": print(current_interaction.interact_value)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
