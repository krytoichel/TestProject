extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum {
	IDLE,
	ATTACK,
	CHASE
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()

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
	await get_tree().create_timer(1).timeout
	$AttackDirection/Area2D/CollisionShape2D.disabled = false
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	$AttackDirection/Area2D/CollisionShape2D.disabled = true
	state = IDLE
	
func chase_state():
	direction = (player - position).normalized()
	var direction1 = (player - position).normalized()
	

	
	if direction.x < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
		print(abs(player.x - position.x))
		if abs(player.x - position.x) < 110:
			animPlayer.play("run")
			velocity.x = direction.x * 100
		elif abs(player.x - position.x) > 200: 
			velocity.x = 0
			state = IDLE
	else:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0
		print(abs(player.x - position.x))
		if abs(player.x - position.x) < 110:
			animPlayer.play("run")
			velocity.x = direction.x * 100
		elif abs(player.x - position.x) > 200: 
			velocity.x = 0
			state = IDLE
		
		
	
	


func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)
