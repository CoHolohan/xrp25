# Vegetable.gd
extends RigidBody3D
class_name Vegetable

@export var points: int = 1

var is_sliced: bool = false
signal sliced(veg: Vegetable)

func slice(cut_direction: Vector3 = Vector3.ZERO) -> void:
	# Called when a sword hits this vegetable
	if is_sliced:
		return
	is_sliced = true

	# If you want some debug:
	print("Vegetable sliced and removed")

	emit_signal("sliced", self)
	queue_free()
