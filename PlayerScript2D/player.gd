extends CharacterBody2D

#состояния
enum {
	ATTACK,
	ATTACK2,
	DASH,
	MOVE
}

#переменные
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#добавляем гравитацию
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#переназываем Анимацию и AnimationPlayer
@onready var anim = $CollisionShape2D/AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

#базовые состояния
var health = 100
var shard = 0
var state = MOVE
var combo = false
var atk_cooldown = false

#процессы, происходящие на левеле постоянно
func _physics_process(delta):
	match state:
		ATTACK:
			attack_state()
		ATTACK2:
			attack2_state()
		DASH:
			move_state()
		MOVE:
			move_state()
	if not is_on_floor():
		velocity.y += gravity * delta	
	move_and_slide()
	
#наша State Machine
func move_state():
	
	#Список действий Вправо Влево
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play('Run')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play('Idle')
			
	#переворачивание влево персонажа	
	if direction == -1:
		anim.flip_h = true
		
	elif direction == 1:
		anim.flip_h = false
		
	#прыжок
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play('Jump')
	if velocity.y > 0:
		animPlayer.play('Fall')
	
	#смерть
	if health <= 0:
		health = 0
		animPlayer.play('Death')
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://MainMenuScript2D/menu.tscn")
	
	#атака
	if Input.is_action_just_pressed('attack'):
		state = ATTACK
	
func attack_state():
	if Input.is_action_just_pressed('attack') and combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play('Attack')
	await animPlayer.animation_finished
	atk_freeze()
	state = MOVE

func attack2_state():
	animPlayer.play('Attack1')
	await animPlayer.animation_finished
	state = MOVE

func combo_():
	combo = true
	await animPlayer.animation_finished
	combo = false
		
func atk_freeze():
	atk_cooldown = true
	await get_tree().create_timer(0.5).timeout
	atk_cooldown = false
	

	
	
	
		
		
	
	
		
	
	
	
	
	
