extends Sprite

export(Array, Texture) var faces

func roll():
	if !$RollAnimation.is_playing():
		$RollAnimation.play("RollAnimation")
func set_random_face():
	if faces.size() > 0:
		$Face.texture = faces[randi() % faces.size()]
