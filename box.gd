extends StaticBody3D
var vida = 5

func dano(valor):
	vida -= valor
	if vida <= 0:
		queue_free()
