extends CharacterBody2D

@export var velocidad = 50
@export var distancia = 100  # distancia de patrulla izquierda/derecha
@export var tiempo_disparo = 3.0

@onready var sprite = $AnimatedSprite2D
@onready var bala = preload("res://bala_enemy.tscn")  # ← cambiá el path si es necesario
	
var direccion = 1
var posicion_inicial
var vida = 3

func _ready():
	posicion_inicial = global_position
	$Timer.wait_time = tiempo_disparo
	$Timer.start()

func _physics_process(delta):
	patrullar(delta)

func patrullar(delta):
	var desplazamiento = global_position.x - posicion_inicial.x
	if abs(desplazamiento) > distancia:
		direccion *= -1
		sprite.flip_h = (direccion < 0)

	velocity.x = direccion * velocidad
	move_and_slide()



func recibir_daño():
	vida -= 1
	print("El enemigo recibió daño. Vida restante:", vida)
	if vida <= 0:
		queue_free()


func _on_timer_timeout() -> void: 
	print("¡Disparo!")
	var player = get_tree().get_first_node_in_group("jugador")
	if player:
		var nueva_bala = bala.instantiate()
		print("Tipo de bala:", typeof(nueva_bala), nueva_bala.get_class())
		nueva_bala.global_position = global_position
		var dir = (player.global_position - global_position).normalized()
		nueva_bala.direccion = dir
		get_tree().current_scene.add_child(nueva_bala)
# Replace with function body.
