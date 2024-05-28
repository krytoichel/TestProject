extends CharacterBody2D

signal health_changed (new_health)
#состояния
enum {
	ATTACK_RUB,
	ATTACK_KOL,
	ATTACK_RUB1,
	ATTACK_KOL1,
	CLIMB,
	HIT,
	KICK,
	ROLL,
	SHIELD,
	RUN,
	DAMAGE,
	DEATH
	
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
var max_health = 100
var health
var shard = 0
var state = RUN
var combo1 = false
var combo2 = false
var attack_cooldown = false
var state_cooldown = false
var player_pos 


func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health

#процессы, происходящие на левеле постоянно
func _physics_process(delta):
	match state:
		ATTACK_RUB:
			attack1_state()#1
		ATTACK_KOL:
			attack2_state()#1
		ATTACK_RUB1:
			attack11_state()#1
		ATTACK_KOL1:	
			attack22_state()#1
		CLIMB:
			move_state()
		HIT:
			move_state()
		KICK:
			kick_state()#1
		ROLL:
			roll_state()#1
		SHIELD:
			shield_state()#1
		RUN:
			move_state()#1
		DAMAGE:
			damage_state()
		DEATH:
			death_state()
			
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y > 0:
		animPlayer.play('Fall')
	
	
	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)
	
	
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

		#блок
		if Input.is_action_pressed('shield') and velocity.y == 0:
			state = SHIELD
		
		#кувырок
		if Input.is_action_just_pressed('roll') and velocity.x != 0 and velocity.y == 0:
			state = ROLL
			
		#атака1
		if Input.is_action_just_pressed('attack_rub') and attack_cooldown == false:
			state = ATTACK_RUB
			
		#атака2
		if Input.is_action_just_pressed('attack_kol') and attack_cooldown == false:
			state = ATTACK_KOL
		
		#кик
		if Input.is_action_just_pressed('kick'):
			state = KICK
			
func shield_state():
	velocity.x = 0
	animPlayer.play('Shield_active', -1, 1.0, true)
	if Input.is_action_just_released('shield'):
		state = RUN
	
func roll_state():
	animPlayer.play('Roll')
	await animPlayer.animation_finished
	state_freeze()
	state = RUN

func attack1_state():
	if Input.is_action_just_pressed('attack_rub') and combo1 == true:
		state = ATTACK_RUB1
	velocity.x = 0
	animPlayer.play('Attack4')
	await animPlayer.animation_finished
	attack_freeze()
	state = RUN

func attack11_state():
	animPlayer.play('Attack1')
	await animPlayer.animation_finished
	attack_freeze()
	state = RUN

func attack2_state():
	if Input.is_action_just_pressed('attack_kol') and combo2 == true:
		state = ATTACK_KOL1
	velocity.x = 0
	animPlayer.play('Attack2')
	await animPlayer.animation_finished
	attack_freeze()
	state = RUN

func attack22_state():
	animPlayer.play('Attack3')
	await animPlayer.animation_finished
	attack_freeze()
	state = RUN

func combo1_state():
	combo1 = true
	await animPlayer.animation_finished
	combo1 = false

func combo2_state():
	combo2 = true
	await animPlayer.animation_finished
	combo2 = false

func kick_state():
	velocity.x = 0
	animPlayer.play('Kick')
	await animPlayer.animation_finished
	state_freeze()
	state = RUN

func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.1).timeout
	attack_cooldown = false

func state_freeze():
	state_cooldown = true
	await get_tree().create_timer(10.0).timeout
	state_cooldown = false
	
func damage_state():
	velocity.x = 0
	animPlayer.play("Hit_idle_B")
	await animPlayer.animation_finished
	state = RUN
	

	

func _on_damage_received(enemy_damage):
	state = DAMAGE
	health -= enemy_damage
	if health <= 0:
		state = DEATH
	emit_signal('health_changed', health)
func death_state():
	anim.position.y = -14
	health = 0
	animPlayer.play('Death')
	await animPlayer.animation_finished
	queue_free()
	get_tree().change_scene_to_file('res://MainMenuScript2D/menu.tscn')


	
	
	

	
	
	
		
		
	
	
		
	
	
	
	
	
