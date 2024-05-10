extends CharacterBody2D

#состояния
enum {
	ATTACK_RUB,
	ATTACK_KOL,
	CLIMB,
	DEATH,
	FALL,
	HIT,
	JUMP,
	KICK,
	ROLL,
	SHIELD,
	RUN
}

#переменные
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#добавляем гравитацию
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#привязываем Анимацию и AnimationPlayer
@onready var anim = $CollisionShape2D/AnimatedSprite2D 
@onready var animPlayer = $AnimationPlayer

#базовые состояния
var health = 100
var shard = 0
var state = RUN

#процессы, происходящие на левеле постоянно
func _physics_process(delta):
	match state:
		ATTACK_RUB:
			move_state()
		ATTACK_KOL:
			move_state()
		CLIMB:
			move_state()
		DEATH:
			move_state()
		FALL:
			move_state()
		HIT:
			move_state()
		JUMP:
			move_state()
		KICK:
			move_state()
		ROLL:
			move_state()
		SHIELD:
			move_state()
		RUN:
			move_state()
			
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y > 0:
		animPlayer.play('Fall')
	if health <= 0:
		anim.position.y = -14
		health = 0
		animPlayer.play('Death')
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://MainMenuScript2D/menu.tscn")
	
	move_and_slide()
	
#наша State Machine
func move_state():
	if health > 0:
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
		if direction == -1 and health > 0:
			anim.position.x = -15
			anim.flip_h = true
		elif direction == 1 and health > 0:
			anim.position.x = 15
			anim.flip_h = false
			
		#прыжок
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animPlayer.play('Jump')

		#атака
		if Input.is_action_just_pressed('attack_rub'):
			state = ATTACK_RUB

	
	

	
	
	
		
		
	
	
		
	
	
	
	
	
