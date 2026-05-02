extends CharacterBody3D

const SPEED = 8

@onready var camera = $Camera3D
@onready var anim = $"character-n/AnimationPlayer"

const decal = preload("res://decal.tscn")
const bala = preload("res://Bala.tscn")
const impact = preload("res://Explosao.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim.play("idle")

func _physics_process(delta):
	var input_dir = Input.get_vector("esquerda", "direita", "cima", "baixo")
	var move = Vector3(input_dir.x, 0, input_dir.y)
	move = move.rotated(Vector3.UP, rotation.y)
	velocity.x = move.x * SPEED
	velocity.z = move.z * SPEED
	move_and_slide()

	if velocity.length() > 0.1:
		if anim.current_animation != "walk":
			anim.play("walk")
	else:
		if anim.current_animation != "idle":
			anim.play("idle")

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y += -event.relative.x * 0.01
		camera.rotation.x += -event.relative.y * 0.01
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		atirar()

func atirar():
	criar_bala()
	var alvo = raycast()

	if alvo != null:
		if alvo.collider.has_method("dano"):
			alvo.collider.dano(50)
			criar_impacto(alvo)
		else:
			criar_decal(alvo)
			criar_impacto(alvo)

func raycast():
	var origem = camera.global_transform.origin
	var direcao = -camera.global_transform.basis.z * 1000
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origem, origem + direcao)
	query.exclude = [$"."]
	var result = space.intersect_ray(query)
	if result.is_empty():
		return null
	return result

func criar_bala():
	var b = bala.instantiate()
	get_parent().add_child(b)
	b.global_position = camera.global_transform.origin + (-camera.global_transform.basis.z * 1.5)
	b.direction = -camera.global_transform.basis.z
	b.look_at(b.global_position + b.direction, Vector3.UP)

func criar_decal(alvo):
	var dcl = decal.instantiate()
	get_parent().add_child(dcl)
	dcl.global_position = alvo.position + (alvo.normal * 0.02)
	dcl.look_at(alvo.position + alvo.normal, Vector3.UP, true)

func criar_impacto(alvo):
	var im = impact.instantiate()
	get_parent().add_child(im)
	im.global_position = alvo.position + (alvo.normal * 0.02)
