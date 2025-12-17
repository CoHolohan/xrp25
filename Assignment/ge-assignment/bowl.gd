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
			veg.queue_free()
		else:
			# Not sliced: let it pass through / keep falling to floor killzone
			pass
