class_name PlayerController
extends PhysicsBody2D


@export var max_falling_speed := 2.99804688
@export var gravity := 0.15625
@export var jumping_gravity := 0.0625
@export var jump_speed := 2.5

@export var max_walking_speed := 1.5859375
@export var walking_accel := 0.166015625
@export var air_control := 0.0625
@export var friction := 0.099609375

var velocity: Vector2
var is_on_ground: bool

var direction: Direction:
	get:
		return ($Sprite2D as Sprite2D).frame_coords.y & 1

enum Direction {
	LEFT,
	RIGHT
}


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
	
	var vertical_collision := move_and_collide(Vector2(0, -velocity.y))
	if vertical_collision != null:
		is_on_ground = velocity.y < 0
		velocity.y = 0
		# TODO: 1-pixel grace distance thing
	else:
		is_on_ground = false
	
	var horizontal_collision := move_and_collide(Vector2(velocity.x, 0))
	if horizontal_collision != null:
		# TODO: Slopes
		velocity.x = 0


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("left"):
			($Sprite2D as Sprite2D).frame_coords.y &= 2
		if event.is_action_pressed("right"):
			($Sprite2D as Sprite2D).frame_coords.y |= 1
