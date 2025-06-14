extends CharacterBody2D

var estaSaltando=false

const SPEED=300.0
const JUMP_VELOCITY= -400.0

@export var atacando=false

@onready var spriteAnimado=$AnimatedSprite2D
@onready var bala=preload("res://bala.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("E"):
		ataque()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Q"):
		var bullet_temp = bala.instantiate()
		bullet_temp.global_position = global_position
		var dir = (get_global_mouse_position() - global_position).normalized()
		bullet_temp.direccion = dir
		get_tree().current_scene.add_child(bullet_temp)
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		estaSaltando=false	
	# Handle jump.
	if Input.is_action_just_pressed("Arriba") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		estaSaltando=true

	var direction := Input.get_axis("Izquierda", "Derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	actualizarAnimacion(direction)
	move_and_slide()
	
	
func actualizarAnimacion(direction):
	if estaSaltando:
		spriteAnimado.play("saltar")
	elif direction != 0:
		spriteAnimado.flip_h = (direction < 0)
		if Input.is_key_pressed(KEY_SHIFT):
			spriteAnimado.play("correr")
		else:
			spriteAnimado.play("caminar")
	else:
		spriteAnimado.play("default")

func ataque():
	var ovelaping_objects = $AreaDeAtaque.get_overlapping_areas()
	
	for area in ovelaping_objects:
		var parent= area.get_parent()
		if parent.is_in_group("enemy"):
			parent.queue_free() #cambiar por parent.recibirDaño() o por el estilo si el enemigo no muere al toque
	
	atacando=true
	#spriteAnimado.play("ataque")
