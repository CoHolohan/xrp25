# VegetableSpawner.gd
extends Node3D

@export var vegetable_scene: Vegetable
@export var spawn_interval: float = 1.0
@export var spawn_radius: float = 1.5
@export var spawn_height: float = 1.5
@export var launch_force: float = 10.0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if vegetable_scene == null:
		push_warning("VegetableSpawner: vegetable_scene is not assigned!")
		return

	var veg: Vegetable = vegetable_scene.instantiate() as Vegetable
	if veg == null:
		push_warning("VegetableSpawner: scene is not a Vegetable")
		return

	# Random X/Z around spawner, at a height
	var rand_x = randf_range(-spawn_radius, spawn_radius)
	var rand_z = randf_range(-spawn_radius, spawn_radius)

	var spawn_pos = global_transform.origin + Vector3(rand_x, spawn_height, rand_z)
	veg.global_transform.origin = spawn_pos

	# Give it an upward launch (like Fruit Ninja)
	var impulse = Vector3(
		randf_range(-1.0, 1.0),
		1.0,
		randf_range(-1.0, 1.0)
	).normalized() * launch_force

	add_child(veg)
	veg.apply_impulse(impulse)
