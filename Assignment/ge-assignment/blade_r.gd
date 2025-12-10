extends Area3D

@export var blade_id: String = "RightHand"  # Just for debugging / identification

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("Blade ", blade_id, " hit: ", body.name, " type: ", body.get_class(), " script: ", body.get_script())

	if body is Vegetable:
		var veg: Vegetable = body
		var cut_dir: Vector3 = -global_transform.basis.z  # sword forward dir
		print("Calling slice() on Vegetable: ", veg.name)
		veg.slice(cut_dir)
