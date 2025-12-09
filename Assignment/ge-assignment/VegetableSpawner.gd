# VegetableSpawner.gd
extends Node3D

@export var vegetable_scene: PackedScene
@export var spawn_every: float = 1.0
@export var spawn_height: float = 2.0
@export var spawn_radius: float = 1.5
@export var launch_speed: float = 6.0

var _time_accum: float = 0.0

func _process(delta: float) -> void:
	_time_accum += delta
	if _time_accum >= spawn_every:
		_time_accum = 0.0
		_spawn_vegetable()

func _spawn_vegetable() -> void:
	if vegetable_scene == null:
		push_warning("VegetableSpawner: assign vegetable_scene in the Inspector")
		return

	var veg = vegetable_scene.instantiate()
	if veg == null:
		push_warning("VegetableSpawner: vegetable_scene is invalid")
		return

	# Random position around the spawner, above it
	var rand_x = randf_range(-spawn_radius, spawn_radius)
	var rand_z = randf_range(-spawn_radius, spawn_radius)

	var spawn_pos = global_transform.origin + Vector3(rand_x, spawn_height, rand_z)
	veg.global_transform.origin = spawn_pos

	# Add veggie to the same scene as the spawner
	get_tree().current_scene.add_child(veg)

	# Launch upwards a bit (Godot 4 style)
	if veg is RigidBody3D:
		var dir = Vector3(
			randf_range(-0.5, 0.5),
			1.0,
			randf_range(-0.5, 0.5)
		).normalized()
		veg.linear_velocity = dir * launch_speed

	print("Spawned veg at: ", spawn_pos)
