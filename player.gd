extends CharacterBody2D

var estaSaltando = false
var puedeDisparar = true
var atacando = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DISTANCIA_AREA_ATAQUE = 30

var vida = 5
var vida_maxima = 5

@onready var barra_vida = $BarraDeVida
@onready var spriteAnimado = $AnimatedSprite2D
@onready var bala = preload("res://bala.tscn")
@onready var areaDeAtaque = $AreaDeAtaque

var anim_actual = ""

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("E") and not atacando:
		ataque()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Q") and puedeDisparar and not atacando:
		disparar()

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		estaSaltando = false	

	if Input.is_action_just_pressed("Arriba") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		estaSaltando = true

	var direction := Input.get_axis("Izquierda", "Derecha")
	if direction:
		velocity.x = direction * SPEED
		spriteAnimado.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if spriteAnimado.flip_h:
		areaDeAtaque.position.x = -DISTANCIA_AREA_ATAQUE
	else:
		areaDeAtaque.position.x = DISTANCIA_AREA_ATAQUE

	if not atacando:
		actualizarAnimacion(direction)

	move_and_slide()

func actualizarAnimacion(direction):
	var anim = ""

	if estaSaltando:
		anim = "saltarBroken" if not puedeDisparar else "saltar"
	elif direction != 0:
		anim = "caminarBroken" if not puedeDisparar else "caminar"
	else:
		anim = "defaultBroken" if not puedeDisparar else "default"

	if anim != anim_actual:
		spriteAnimado.play(anim)
		anim_actual = anim

func ataque():
	atacando = true

	var overlapping_objects = areaDeAtaque.get_overlapping_bodies()
	var anim = "meleeBROKEN" if not puedeDisparar else "melee"
	spriteAnimado.play(anim)
	anim_actual = anim

	for body in overlapping_objects:
		if body.is_in_group("enemy"):
			body.queue_free()
			print("recibirDañoEnemigo")

	await spriteAnimado.animation_finished
	atacando = false
	anim_actual = ""

func disparar() -> void:
	puedeDisparar = false

	var direction := Input.get_axis("Izquierda", "Derecha")
	if direction != 0:
		spriteAnimado.play("attack_walk")
	else:
		spriteAnimado.play("attack2")
	anim_actual = "disparando"

	var bullet_temp = bala.instantiate()
	bullet_temp.global_position = global_position
	var dir = (get_global_mouse_position() - global_position).normalized()
	bullet_temp.direccion = dir
	get_tree().current_scene.add_child(bullet_temp)

	await get_tree().create_timer(0.5).timeout
	puedeDisparar = true
	anim_actual = ""

func recibir_daño():
	vida -= 1
	barra_vida.value = vida
	print("jugador dañado")

	if puedeDisparar:
		var resultado = randi_range(1, 5)
		print("Resultado del dado de disparo:", resultado)
		if resultado == 2 or resultado == 4:
			puedeDisparar = false
			print("¡Desactivado el disparo!")

	if vida <= 0:
		morir()

func _on_body_entered(_body: Node2D) -> void:
	pass

func morir():
	print("El jugador ha muerto")
	get_tree().reload_current_scene()
