extends CharacterBody2D

# Variáveis exportadas para configurar no Inspector
@export var speed: float = 100.0

# Referências aos nós
@onready var animation = $AnimatedSprite2D 
@onready var camera = $Camera2D

var can_die: bool = false
var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	# Se estiver morto ou atacando, bloqueia o movimento
	if not can_die and not is_attacking:
		move()
		animate()
	
	# O move_and_slide() no Godot 4 usa a variável 'velocity' automaticamente
	move_and_slide()

func move() -> void:
	# Input.get_vector simplifica a captura das 4 direções em um único Vector2
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func animate() -> void:
	# Lógica de ataque (prioridade sobre movimento)
	if Input.is_action_just_pressed("ui_accept"):
		is_attacking = true
		animation.play("Attack")
		return

	# Lógica de animação de movimento
	if velocity != Vector2.ZERO:
		animation.play("corre")
		animation.flip_h = velocity.x < 0
	else:
		animation.play("dle")

# Sinal conectado do AnimatedSprite2D: animation_finished
func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "Attack":
		is_attacking = false
	elif animation.animation == "Death":
		get_tree().reload_current_scene()
