# BowlArea.gd
extends Area3D

signal fruit_scored(points: int)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("fruit_half"):
		emit_signal("fruit_scored", 1)
		body.queue_free()
