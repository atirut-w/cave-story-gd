extends PhysicsBody2D


@export var max_falling_speed := 0x5ff
@export var gravity := 0x50
@export var jumping_gravity := 0x20
@export var jump_speed := 0x500

var velocity: Vector2
var is_on_ground: bool


func _physics_process(delta: float):
	if velocity.y > max_falling_speed:
		velocity.y = max_falling_speed
	if !Input.is_action_pressed("jump") || (velocity.y < 0):
		velocity.y -= gravity
	if Input.is_action_pressed("jump") && (velocity.y >= 0):
		velocity.y -= jumping_gravity
	if is_on_ground && Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	
	var vertical_collision := move_and_collide(Vector2(0, -velocity.y) / 0x200)
	is_on_ground = velocity.y < 0 && vertical_collision != null
