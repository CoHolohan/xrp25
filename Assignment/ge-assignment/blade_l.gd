
extends Area3D

@export var blade_id: String = "LeftHand"  # Just for debugging / identification


func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Vegetable:
		var veg: Vegetable = body
		var cut_dir: Vector3 = -global_transform.basis.z  # sword forward dir
		veg.slice(cut_dir)  # this will queue_free() the vegetable
