extends Node3D

var vida = 10

@onready var anim = $Slime/AnimationPlayer

func _process(delta):
	if not anim.is_playing():
		anim.play("Armature|IDLE")

func dano(valor):
	vida -= valor
	if vida <= 0:
		queue_free()
