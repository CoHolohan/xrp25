# FloorKillZone.gd
extends Area3D

@export var miss_sounds: Array[AudioStream] = []
@onready var miss_player: AudioStreamPlayer3D = get_node_or_null("MissSound")

func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Vegetable:
		print("Vegetable hit floor and was removed")
		var veg: Vegetable = body
		
		if not veg.is_sliced:
			if miss_player and not miss_sounds.is_empty():
				miss_player.global_position = veg.global_position
				miss_player.stream = miss_sounds[randi_range(0, miss_sounds.size() - 1)]
				miss_player.pitch_scale = randf_range(0.9, 1.1)
				miss_player.play() 
			
		body.queue_free()
