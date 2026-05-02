extends Node3D

@onready var anim = $Slime/AnimationPlayer

func _process(delta):
	if not anim.is_playing():
		anim.play("Armature|IDLE")

func dano(valor):
	get_tree().reload_current_scene()
