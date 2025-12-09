# vegSpawner.gd
extends Node3D

@export var vegs: Array[PackedScene] = []
@export var spawn_area_size: Vector2 = Vector2(2.0, 2.0) # XZ area
@export var spawn_height: float = 3.0
@export var spawn_interval: float = 1.0

var timer: Timer

func _ready() -> void:
	randomize()
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timeout)


func _on_timeout() -> void:
	if vegs.is_empty():
		return

	var veg_scene: PackedScene = vegs[randi() % vegs.size()]
	var veg: RigidBody3D = veg_scene.instantiate()

	# Random X/Z within spawn area
	var x = randf_range(-spawn_area_size.x * 0.5, spawn_area_size.x * 0.5)
	var z = randf_range(-spawn_area_size.y * 0.5, spawn_area_size.y * 0.5)

	var spawn_pos = global_transform.origin + Vector3(x, spawn_height, z)
	veg.global_transform.origin = spawn_pos

	get_tree().current_scene.add_child(veg)
