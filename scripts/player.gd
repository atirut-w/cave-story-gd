extends PhysicsBody2D


@export var max_falling_speed := 0x5ff
@export var gravity := 0x50
@export var jumping_gravity := 0x20
@export var jump_speed := 0x500

@export var max_walking_speed := 0x32c
@export var walking_accel := 0x55
@export var air_control := 0x20
@export var friction := 0x33

var velocity: Vector2
var is_on_ground: bool


func _physics_process(delta: float):
	velocity.y = clamp(velocity.y, -max_falling_speed, max_falling_speed)
	if !Input.is_action_pressed("jump") || (velocity.y < 0):
		velocity.y -= gravity
	if Input.is_action_pressed("jump") && (velocity.y >= 0):
		velocity.y -= jumping_gravity
	if is_on_ground && Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	
	velocity.x = clamp(velocity.x, -max_walking_speed, max_walking_speed)
	if is_on_ground:
		if Input.is_action_pressed("left"):
			velocity.x -= walking_accel
		elif Input.is_action_pressed("right"):
			velocity.x += walking_accel
		
		velocity.x -= clamp(velocity.x, -friction, friction)
	else:
		if Input.is_action_pressed("left"):
			velocity.x -= air_control
		elif Input.is_action_pressed("right"):
			velocity.x += air_control
	
	var vertical_collision := move_and_collide(Vector2(0, -velocity.y) / 0x200)
	is_on_ground = velocity.y < 0 && vertical_collision != null
	# TODO: 1-pixel grace distance thing
	
	var horizontal_collision := move_and_collide(Vector2(velocity.x, 0) / 0x200)
