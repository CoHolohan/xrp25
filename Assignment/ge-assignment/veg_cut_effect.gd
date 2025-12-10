extends GPUParticles3D

func _ready() -> void:
	one_shot = true
	emitting = true
	var t := get_tree().create_timer(lifetime)
	t.timeout.connect(func(): queue_free())
