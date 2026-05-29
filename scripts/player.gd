extends CharacterBody2D

@export var speed: float = 100.0

@onready var animation = $AnimatedSprite2D 
@onready var camera = $Camera2D

var can_die: bool = false
var is_attacking: bool = false

# Usamos o _unhandled_input para detectar o ataque de forma limpa
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and not is_attacking:
		is_attacking = true
		animation.play("Attack")

func _physics_process(_delta: float) -> void:
	# O movimento só ocorre se não estiver atacando
	if not is_attacking:
		move()
		animate()
	else:
		# Se estiver atacando, paramos o jogador
		velocity = Vector2.ZERO
	
	move_and_slide()

func move() -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("corre")
		animation.flip_h = velocity.x < 0
	else:
		animation.play("idle") # Corrigido para "idle"

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "Attack":
		is_attacking = false
	elif animation.animation == "Death":
		get_tree().reload_current_scene()
