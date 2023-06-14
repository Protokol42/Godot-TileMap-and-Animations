extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_velocity : float = -300.0
@export var double_jump_velocity : float = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_velocity #Normal Jump
		elif not has_double_jumped:
			has_double_jumped = true
			velocity.y = double_jump_velocity #Double Jump
	
	# Handle Double Jump
	if is_on_floor():
		has_double_jumped = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
