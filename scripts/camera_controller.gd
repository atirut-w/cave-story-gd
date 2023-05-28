extends Camera2D


@export var target: Node2D
@export var focus_speed := 16
@export var soft_quake := false
@export var hard_quake := false

var _target_position: Vector2


func _physics_process(delta: float) -> void:
	if target != null:
		_target_position = target.position
	
	var focus := _target_position - position
	position.x += focus.x / focus_speed
	position.y += focus.y / focus_speed
	
	# TODO: Soft & hard quakes
