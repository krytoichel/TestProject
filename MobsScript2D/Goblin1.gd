extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var chase1 = false


var speed = 100

@onready var anim = $AnimatedSprite2D 
var alive = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true and chase1 == false:
			velocity.x = direction.x * speed
			anim.play('run')
			if abs(player.position.x - self.position.x) < 30:
				anim.play("idle")
		#elif chase == false and chase1 == true:
			#velocity.x = 0
			##anim.play("Attack")
			##await anim.animation_finished
		
			
		elif chase == false and chase1 == false:
			velocity.x = 0
			anim.play('idle')
			
		#if chase1 == true:
			#chase = false
			#anim.play("")
			#anim.stop()
			#await anim.animation_finished
			#anim.play("Attack")
		#else:
			#chase = false
			
		
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == 'Player':
		chase = true
		chase1 = false


func _on_detector_body_exited(body):
	if body.name == 'Player':
		chase = false
		chase1 = false


func _on_death_body_entered(body):
	if body.name == 'Player':
		body.velocity.y -= 200
		death()
#
#func _on_death_2_body_entered(body):
	#if body.name == 'Player':
		##if alive == true:
			##body.health -= 40
			##death()
#
func death():
	alive = false
	anim.play('death')
	await anim.animation_finished
	queue_free()
	





func _on_detector_atack_body_entered(body):
	if body.name == 'Player':
		chase1 = true
		chase = false
		anim.play("Attack")
		await get_tree().create_timer(0.8).timeout
		body.anim.play("Hit_idle_B")
		body.health -= 20
		var det = $DetectorAtack/CollisionShape2D
		det.disabled = 1
		await get_tree().create_timer(1).timeout
		det.disabled = 0
		anim.speed_scale = 1
		#await get_tree().create_timer(1).timeout


func _on_detector_atack_body_exited(body):
	if body.name == 'Player':
		chase1 = false
		chase = true
	





