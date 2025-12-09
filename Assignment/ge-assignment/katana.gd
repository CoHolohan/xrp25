extends RigidBody3D
class_name Katana

## Minimum swing speed (m/s) before we consider this a "cut"
@export var min_cut_speed: float = 1.5

## Extra speed given to fruit halves when cut
@export var cut_impulse: float = 5.0

## Path to the Area3D that covers the blade
@export var blade_area_path: NodePath = ^"BladeArea"

## Optional debug logs
@export var debug: bool = false

var _prev_pos: Vector3
var _current_speed: float = 0.0

@onready var _blade_area: Area3D = get_node(blade_area_path)


func _ready() -> void:
	_prev_pos = global_transform.origin

	if _blade_area:
		_blade_area.body_entered.connect(_on_blade_body_entered)
	elif debug:
		push_warning("Katana: BladeArea not found, no cutting will happen.")


func _physics_process(delta: float) -> void:
	if delta <= 0.0:
		return

	var pos: Vector3 = global_transform.origin
	_current_speed = pos.distance_to(_prev_pos) / delta
	_prev_pos = pos


func _on_blade_body_entered(body: Node) -> void:
	# Require a fast enough swing
	if _current_speed < min_cut_speed:
		if debug:
			print("Katana hit ", body, " but speed (", _current_speed, ") too low to cut.")
		return

	# Only act on fruit
	if not body.is_in_group("fruit"):
		return

	if debug:
		print("Katana slicing ", body, " at speed ", _current_speed)

	# Preferred: the fruit has its own slice() method
	if body.has_method("slice"):
		body.slice(global_transform, cut_impulse)
		return

	# Fallback: just whack it with an impulse
	if body is RigidBody3D:
		var dir := (body.global_transform.origin - global_transform.origin).normalized()
		(body as RigidBody3D).apply_impulse(dir * cut_impulse, Vector3.ZERO)
