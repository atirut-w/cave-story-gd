extends Camera2D


@export var target: Node2D
@export var focus_speed := 16
@export var soft_quake := false
@export var hard_quake := false

var _target_position: Vector2
var _offset: Vector2


func _physics_process(delta: float) -> void:
	if target != null:
		_target_position = target.position
	
	if target is PlayerController:
		if target.direction == PlayerController.Direction.LEFT:
			_offset.x -= 1
		else:
			_offset.x += 1
		
		_offset.x = clamp(_offset.x, -64, 64)
	else:
		_offset = Vector2()
	
	var focus := (_target_position + _offset) - position
	position.x += focus.x / focus_speed
	position.y += focus.y / focus_speed
	
	if soft_quake:
		position += Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if hard_quake:
		position.x += randi_range(-5, 5)
		position.y += randi_range(-3, 3)
