extends CharacterBody2D


@export var speed : float = 220.0
@export var jump_velocity : float = -300.0
@export var double_jump_velocity : float = -250.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var is_in_air : bool = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		is_in_air = true
	else:
		has_double_jumped = false
		if is_in_air:
			land()
			is_in_air = false
	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			jump(jump_velocity,has_double_jumped) # Normal Jump
		elif not has_double_jumped:
			has_double_jumped = true
			animated_sprite.stop()
			jump(double_jump_velocity,has_double_jumped) # Double Jump
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("Left", "Right","Up","Crouch").normalized()
	if direction.x != 0 and animated_sprite.animation != "Jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	update_animations()
	update_facing_direction()
	
func update_animations(): # Update Animations
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("Fall")
		else:
			if direction.x != 0:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("Idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func jump(j_velocity,state : bool):
	if !state:
		animated_sprite.play("Jump_start")
	else:
		animated_sprite.play("Jump_double")
	velocity.y = j_velocity 
	animation_locked = true

func land():
	animated_sprite.play("Jump_end")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished():
	if (["Jump_start","Jump_double","Jump_end"].has(animated_sprite.animation)):
		animation_locked = false
