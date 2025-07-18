extends CharacterBody2D

const VELOCIDAD = 25.0
var velocidad_actual = VELOCIDAD
var direccion = Vector2.ZERO
var jugador_detectado = false
var jugador: Node2D = null
var estaVivo = true

var vida = 3

@onready var spriteAnimado = $AnimatedSprite2D
@onready var rayJugador = $RayCast2D

func _ready():
	add_to_group("enemy")
	rayJugador.enabled = true

func _physics_process(delta):
	if not jugador_detectado and rayJugador.is_colliding():
		var objetivo = rayJugador.get_collider()
		if objetivo.is_in_group("jugador") and objetivo.vida>0:
			jugador_detectado = true
			jugador = objetivo
			velocidad_actual = VELOCIDAD * 2

	if jugador_detectado and jugador != null:
		direccion = (jugador.global_position - global_position).normalized()
		velocity = direccion * velocidad_actual
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	actualizarAnimacion()

func actualizarAnimacion():
	if not spriteAnimado.is_playing():
		spriteAnimado.play("default")

func _on_collision_body_entered(body: Node2D) -> void:
	if !body.is_in_group("jugador") and !body.is_in_group("enemy"):
		queue_free()
	elif body.is_in_group("jugador"):
		body.recibir_daño()
		

func recibir_daño():
	vida -= 1
	print("El enemigo recibió daño. Vida restante:", vida)
	if vida <= 0:
		print("volador Muerto")
		queue_free()
