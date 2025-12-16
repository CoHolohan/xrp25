extends Node3D

@export var vegetable_scenes: Array[PackedScene]   # multiple veg scenes here
@export var spawn_center: Node3D                   # BowlSpawnPoint
@export var score_display: Node3D 
@export var spawn_every: float = 2.0
@export var vertical_offset: float = 8.0
@export var spawn_radius: float = 0.8
@export var launch_speed: float = 0.05

var _time_accum: float = 0.0

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	_time_accum += delta
	if _time_accum >= spawn_every:
		_time_accum = 0.0
		_spawn_vegetable()

func _spawn_vegetable() -> void:
	if vegetable_scenes.is_empty():
		push_warning("VegetableSpawner: add scenes to vegetable_scenes in the Inspector")
		return

	# Pick a random veg type
	var index := randi_range(0, vegetable_scenes.size() - 1)
	var veg_scene: PackedScene = vegetable_scenes[index]

	var veg = veg_scene.instantiate()
	if veg == null:
		push_warning("VegetableSpawner: chosen vegetable scene is invalid")
		return

	get_tree().current_scene.add_child(veg)

	# Base = spawn_center if set, otherwise spawner
	var base_pos: Vector3 = global_position
	if spawn_center:
		base_pos = spawn_center.global_position

	# Random XZ offset around centre
	var rand_x = randf_range(-spawn_radius, spawn_radius) if spawn_radius > 0.0 else 0.0
	var rand_z = randf_range(-spawn_radius, spawn_radius) if spawn_radius > 0.0 else 0.0

	var spawn_pos = base_pos + Vector3(rand_x, vertical_offset, rand_z)
	veg.global_position = spawn_pos

	if veg is RigidBody3D:
	# Slight sideways drift + downward fall
		var dir := Vector3(
			randf_range(-0.35, 0.35),  # X drift
			-1.0,                      # Y down
			randf_range(-0.35, 0.35)   # Z drift
		).normalized()

		veg.linear_velocity = dir * launch_speed

		# Random tumble/spin (radians per second)
		veg.angular_velocity = Vector3(
			randf_range(-4.0, 4.0),
			randf_range(-4.0, 4.0),
			randf_range(-4.0, 4.0)
		)

	print("Spawned veg type ", index, " at: ", spawn_pos)
	

	# Connect sliced signal to score display
	if score_display and veg is Vegetable:
		veg.sliced.connect(score_display._on_vegetable_sliced)
