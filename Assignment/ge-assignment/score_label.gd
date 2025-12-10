extends Label3D

var score: int = 0

func _ready() -> void:
	text = "0"

func _on_vegetable_sliced(_veg: Vegetable) -> void:
	score += 1
	text = str(score)
