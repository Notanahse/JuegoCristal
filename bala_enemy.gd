extends Area2D

@export var velocidad = 100.0
var direccion = Vector2.ZERO

func _physics_process(delta):
	position += direccion * velocidad * delta

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		if body.has_method("recibir_daño"):
			body.recibir_daño()
		queue_free()
	elif !body.is_in_group("enemy"):
		queue_free()  # destruye la bala si toca algo más
