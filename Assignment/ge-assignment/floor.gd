extends Area3D

@export var miss_sounds: Array[AudioStream] = []
@onready var miss_player: AudioStreamPlayer3D = $MissSound

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Vegetable:
		var veg: Vegetable = body
		print("FLOOR HIT:", veg.name, " sliced=", veg.is_sliced, " at ", veg.global_position)

		if not veg.is_sliced and miss_player:
			# Choose a sound: array if provided, otherwise use the player's assigned stream
			if not miss_sounds.is_empty():
				miss_player.stream = miss_sounds[randi_range(0, miss_sounds.size() - 1)]
			elif miss_player.stream == null:
				push_warning("MissSound has no stream AND miss_sounds is empty.")
				veg.queue_free()
				return

			miss_player.global_position = veg.global_position
			miss_player.pitch_scale = randf_range(0.9, 1.1)
			miss_player.play()

		veg.queue_free()
