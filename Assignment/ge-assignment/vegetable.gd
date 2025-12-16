extends RigidBody3D
class_name Vegetable

@export var points: int = 1
@export var cut_effect_scene: PackedScene
@export var gravity_scale_falling: float = 0.5


var is_sliced: bool = false
signal sliced(veg: Vegetable)

func _ready() -> void:
	gravity_scale = gravity_scale_falling
	print("Vegetable READY: ", name, " script: ", get_script())

func slice(_cut_direction: Vector3 = Vector3.ZERO) -> void:
	if is_sliced:
		return
	is_sliced = true

	print(">>> slice() CALLED on: ", name)

	# Spawn particle effect at veg position
	if cut_effect_scene:
		var fx = cut_effect_scene.instantiate()
		get_tree().current_scene.add_child(fx)

		if fx is Node3D:
			fx.global_position = global_position

		if fx is GPUParticles3D:
			fx.one_shot = true
			fx.emitting = false
			fx.restart()
			fx.emitting = true

			var t := get_tree().create_timer(fx.lifetime)
			t.timeout.connect(func ():
				if is_instance_valid(fx):
					fx.queue_free())
	else:
		push_warning("Vegetable has NO cut_effect_scene assigned!")

	emit_signal("sliced", self)
	queue_free()
