extends RigidBody3D
class_name Vegetable

@export var sliced_material: Material
@export var unsliced_material: Material
@export var points: int = 1

var is_sliced: bool = false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $SliceParticles

signal sliced(veg: Vegetable)

func _ready() -> void:
	if unsliced_material and mesh:
		mesh.material_override = unsliced_material

func slice(cut_direction: Vector3) -> void:
	if is_sliced:
		return
	is_sliced = true

	# Optional: extra gravity / kick
	gravity_scale = 3.0
	if cut_direction != Vector3.ZERO:
		linear_velocity += -cut_direction.normalized() * 4.0

	# Hide the solid mesh
	if mesh:
		mesh.visible = false

	# Disable collisions so it doesn’t get hit again
	collision_layer = 0
	collision_mask = 0

	# Play particle explosion
	if particles:
		particles.emitting = true

	emit_signal("sliced", self)

	# Remove the node after particles finish
	var lifetime := particles and particles.lifetime or 1.0
	await get_tree().create_timer(lifetime).timeout
	queue_free()
