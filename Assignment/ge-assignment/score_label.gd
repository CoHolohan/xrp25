extends Label3D

@export var milestone_every: int = 5
@export var milestone_sounds: Array[AudioStream] = []

@onready var score_player: AudioStreamPlayer3D = get_node_or_null("ScoreSound")

var score: int = 0

func _ready() -> void:
	text = "0"

func _on_vegetable_sliced(_veg: Vegetable) -> void:
	score += 1
	text = str(score)

	# Play sound only on milestones (5, 10, 15, ...)
	if milestone_every > 0 and score % milestone_every == 0:
		if score_player:
			# If you provided multiple sounds, pick a random one
			if not milestone_sounds.is_empty():
				score_player.stream = milestone_sounds[randi_range(0, milestone_sounds.size() - 1)]
			score_player.pitch_scale = randf_range(0.98, 1.02)
			score_player.play()
