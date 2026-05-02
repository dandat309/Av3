extends AnimatedSprite3D

func _ready():
	play("efeito")
	animation_finished.connect(_on_finish)

func _on_finish():
	queue_free()
