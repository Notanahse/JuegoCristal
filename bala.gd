extends Area2D

var velocidad = 500
var direccion = Vector2.ZERO

func _ready() -> void:
	rotation = direccion.angle()


func _process(delta):
	position += direccion * velocidad * delta

func _on_body_entered(body):
	print("Colisión con:", body.name)
	if body.is_in_group("enemy"):
		if body.has_method("recibir_daño"):
			body.recibir_daño()
		queue_free()
	elif !body.is_in_group("jugador"):
		queue_free()
