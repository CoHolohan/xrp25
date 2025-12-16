extends Label3D

@export var score_sounds: Array[AudioStream] = []
@onready var score_player: AudioStreamPlayer3D = get_node_or_null("ScoreSound")

var score: int = 0

func _ready() -> void:
	text = "0"

func _on_vegetable_sliced(_veg: Vegetable) -> void:
	score += 1
	text = str(score)
	
	if score_player and not score_sounds.is_empty():
		score_player.stream = score_sounds[randi_range(0, score_sounds.size() - 1)]
		score_player.pitch_scale = randf_range(0.98, 1.02)
		score_player.play()
