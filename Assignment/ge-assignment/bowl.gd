# Bowl.gd
extends Area3D

var score: int = 0

signal score_changed(new_score: int)

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Vegetable:
		var veg: Vegetable = body

		if veg.is_sliced:
			score += veg.points
			emit_signal("score_changed", score)
		else:
			# Optional: penalty if unsliced veg falls in
			# score -= 1
			# emit_signal("score_changed", score)
			pass

		veg.queue_free()
