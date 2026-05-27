extends CharacterBody2D

# Referência ao nó, que será carregado quando a cena iniciar
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Lógica corrigida usando a referência 'animated_sprite'
	if direction > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("anda")
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("anda")
	else:
		animated_sprite.play("idle")
		 
	move_and_slide()
