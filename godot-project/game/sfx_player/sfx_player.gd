extends AudioStreamPlayer2D

class_name SfxPlayer

func play_sfx(sfx_file : AudioStream) -> void:
	if not self.playing:
		self.stream = sfx_file
		self.play()
