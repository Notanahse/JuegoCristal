extends Area2D

var velocidad = 500
var direccion = Vector2.ZERO

func _ready() -> void:
	rotation = direccion.angle()


func _process(delta):
	position += direccion * velocidad * delta
