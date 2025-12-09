
extends Area3D

@export var blade_id: String = "RightHand"  # Just for debugging / identification

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Only slice vegetable objects
	if body is Vegetable:
		var veg: Vegetable = body
		# Use sword forward direction as cut direction
		var cut_dir: Vector3 = -global_transform.basis.z
		veg.slice(cut_dir)
