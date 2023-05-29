class_name PlayerController
extends PhysicsBody2D


@export var max_speed := 2.998046875
@export var max_run_speed := 1.5859375
@export var ground_acceleration := 0.166015625
@export var air_acceleration :=  0.0625
@export var jump_speed := 2.5
@export var fall_gravity := 0.15625
@export var jump_gravity := 0.0625
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
	if is_on_ground:
		if Input.is_action_pressed("left") && velocity.x > -max_run_speed:
			velocity.x -= ground_acceleration
		if Input.is_action_pressed("right") && velocity.x < max_run_speed:
			velocity.x += ground_acceleration
		
		velocity.x -= clamp(velocity.x, -friction, friction)
	else:
		if Input.is_action_pressed("left") && velocity.x > -max_run_speed:
			velocity.x -= air_acceleration
		if Input.is_action_pressed("right") && velocity.x < max_run_speed:
			velocity.x += air_acceleration
	
	if Input.is_action_just_pressed("jump") && is_on_ground:
		velocity.y = -jump_speed
	
	if velocity.y < 0 && Input.is_action_pressed("jump"):
		velocity.y += jump_gravity
	else:
		velocity.y += fall_gravity
	
	velocity = velocity.clamp(
		Vector2(-max_speed, -max_speed),
		Vector2(max_speed, max_speed)
	)
	
	var vertical_collision := move_and_collide(Vector2(0, velocity.y))
	if vertical_collision != null:
		is_on_ground = velocity.y > 0
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
