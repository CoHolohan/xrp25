# FloorKillZone.gd
extends Area3D

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Vegetable:
		print("Vegetable hit floor and was removed")
		body.queue_free()
