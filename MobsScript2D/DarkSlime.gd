extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum {
	IDLE,
	ATTACK,
	CHASE,
	DEATH,
	DAMAGE,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DEATH:
				death_state()
			DAMAGE:
				damage_state()
			RECOVER:
				recover_state()

var speed = 100

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

var alive = true
var player
var direction
var damage = 20

func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == CHASE:
		chase_state()
	

	move_and_slide()


	
func _on_player_position_update(player_pos):
	player = player_pos


func _on_area_2d_body_entered(body):
	state = ATTACK
	
	
func idle_state():
	animPlayer.play("idle")
	
	state = CHASE
	
func attack_state():
	animPlayer.play("attack_A")
	await animPlayer.animation_finished
	state = RECOVER
	
func chase_state():
	direction = (player - position).normalized()
	var direction1 = (player - position).normalized()
	

	
	if direction.x < 0:
		sprite.flip_h = false
		$AttackDirection1.rotation_degrees = 0
		#print(abs(player.x - position.x))
		if abs(player.x - position.x) < 110:
			animPlayer.play("walk")
			velocity.x = direction.x * 100
		elif abs(player.x - position.x) > 200: 
			velocity.x = 0
			state = IDLE
	else:
		sprite.flip_h = true
		$AttackDirection1.rotation_degrees = 180
		#print(abs(player.x - position.x))
		if abs(player.x - position.x) < 110:
			animPlayer.play("walk")
			velocity.x = direction.x * 100
		elif abs(player.x - position.x) > 200: 
			velocity.x = 0
			state = IDLE
		
		
func damage_state():
	animPlayer.play("take_hit")
	await animPlayer.animation_finished
	state = IDLE

func death_state():
	animPlayer.play("death")
	await animPlayer.animation_finished
	queue_free()

func recover_state():
	animPlayer.play("recover")
	await  animPlayer.animation_finished
	state = IDLE	
	


	
func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)





func _on_area_2d_body_exited(body):
	state = IDLE
	
	
	


func _on_mob_health_damage_received():
	state = IDLE
	state = DAMAGE


func _on_mob_health_no_health():
	state = DEATH
