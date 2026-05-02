extends Area3D

@export var speed = 30
var direction = Vector3.ZERO

func _process(delta):
	global_position += direction * speed * delta

func _ready():
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_body_entered(body):
	if body.has_method("dano"):
		body.dano(50)
	
	queue_free()
