extends CharacterBody2D

var velocidad = 100.0
var direccion = -1  # -1 = sube, 1 = baja

func _physics_process(delta):
	# Movimiento solo vertical
	velocity = Vector2(0, velocidad * direccion)

	# move_and_slide ya usa velocity internamente en Godot 4
	move_and_slide()

	# Cambia de dirección si choca con techo o piso
	if is_on_ceiling() or is_on_floor():
		direccion *= -1

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		body.morir()
