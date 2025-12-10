extends Node3D

@export var vegetable_scene: PackedScene
@export var spawn_center: Marker3D       # drag BowlSpawnPoint here
@export var spawn_every: float = 2.0
@export var vertical_offset: float = 8.0   # how high above the centre
@export var spawn_radius: float = 0.0      # 0 = exact centre
@export var launch_speed: float = 0.1

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

	get_tree().current_scene.add_child(veg)

	# Base position = spawn_center (fallback to spawner itself)
	var base_pos: Vector3 = global_position
	if spawn_center:
		base_pos = spawn_center.global_position

	# Random offset around centre (XZ). spawn_radius = 0 -> no offset.
	var rand_x = randf_range(-spawn_radius, spawn_radius) if spawn_radius > 0.0 else 0.0
	var rand_z = randf_range(-spawn_radius, spawn_radius) if spawn_radius > 0.0 else 0.0

	# Spawn above the centre
	var spawn_pos = base_pos + Vector3(rand_x, vertical_offset, rand_z)
	veg.global_position = spawn_pos

	if veg is RigidBody3D:
		var dir = Vector3(0, -1, 0)  # straight down
		veg.linear_velocity = dir * launch_speed

	print("Spawned veg above centre at: ", spawn_pos)
