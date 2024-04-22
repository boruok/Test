extends "../base.gd"


signal keys_changed(keys)
signal hp_changed(current, total)

@onready var inventory := $Inventory

@export var hp_max := 10:
	set(value):
		hp_max = value
		hp_changed.emit(hp, hp_max)
@onready var hp := hp_max:
	set(value):
		hp = value
		hp = clamp(hp, 0, hp_max)
		hp_changed.emit(hp, hp_max)
var keys := 0:
	set(value):
		keys = value
		keys_changed.emit(keys)

var _last_direction := Vector2(0, 0)
var _animation_name := "f_idle"


func _process(delta: float) -> void:
	# direction
	_direction.x = Input.get_axis("ui_left", "ui_right")
	_direction.y = Input.get_axis("ui_up", "ui_down")
	if _direction.x:
		_last_direction.x = _direction.x
		_last_direction.y = 0
	if _direction.y:
		_last_direction.y = _direction.y
		_last_direction.x = 0
	# animation
	if _direction:
		if _direction.x:
			_animation_name = "s_walk"
			_animation.flip_h = _direction.x == -1
		if _direction.y:
			if _direction.y == -1:
				_animation_name = "b_walk"
			else:
				_animation_name = "f_walk"
		_animation.play(_animation_name)
	else:
		_animation.play(_animation_name.get_slice("_", 0) + "_idle")


func _physics_process(delta: float) -> void:
	velocity = _velocity_max * _direction
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_select"):
		var state := get_viewport().world_2d.direct_space_state
		var query := PhysicsRayQueryParameters2D.new()
		query.collide_with_areas = true
		query.hit_from_inside = true
		query.collision_mask = 3 + 1
		query.from = position
		query.to = position + _last_direction * 16  # TODO magic number
		var result := state.intersect_ray(query)

		if !result:
			return  # collided with nothing

		if result.collider is Area2D:
			if position.distance_to(result.collider.position) < 8:    # TODO magic number
				result.collider.collide(self)
		elif result.collider is StaticBody2D:
			result.collider.collide(self)
