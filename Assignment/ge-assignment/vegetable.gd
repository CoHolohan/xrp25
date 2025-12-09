# Vegetable.gd
extends RigidBody3D
class_name Vegetable

@export var sliced_material: Material
@export var unsliced_material: Material
@export var points: int = 1

var is_sliced: bool = false

signal sliced(veg: Vegetable)

func _ready() -> void:
	if unsliced_material and $MeshInstance3D:
		$MeshInstance3D.material_override = unsliced_material

func slice(cut_direction: Vector3) -> void:
	if is_sliced:
		return

	is_sliced = true

	# Make it drop faster after slice
	gravity_scale = 3.0

	# Add a little kick based on sword direction
	if cut_direction != Vector3.ZERO:
		apply_impulse(-cut_direction.normalized() * 4.0)

	# Change material to show it's cut
	if sliced_material and $MeshInstance3D:
		$MeshInstance3D.material_override = sliced_material

	emit_signal("sliced", self)
