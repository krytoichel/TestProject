extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var chase1 = false

var speed = 70

@onready var anim = $AnimatedSprite2D
var alive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if alive == true:
		if chase == true and chase1 == false:
			velocity.x = direction.x * speed
			anim.play('walk')
		
		elif chase == false and chase1 == false:
			velocity.x = 0
			anim.play('idle')
			
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	
	move_and_slide()
	
	


func _on_detector_body_entered(body):
	if body.name == 'Player':
		chase = true
		chase1 = false


func _on_detector_body_exited(body):
	if body.name == 'Player':
		chase = false
		chase1 = false




func death():
	alive = false
	anim.play('death')
	await get_tree().create_timer(0.8).timeout
	queue_free()



func _on_detector_attack_body_entered(body):
	if body.name == 'Player':
		chase1 = true
		chase = false
		anim.play("attack_A")
		await get_tree().create_timer(0.8).timeout
		body.anim.play("Hit_idle_B")
		#await get_tree().create_timer(5)
		#body.health -= 20
		#await get_tree().create_timer(5).timeout




func _on_detector_attack_body_exited(body):
	if body.name == 'Player':
		chase1 = false
		chase = true


func _on_death_body_entered(body):
	if body.name == "Player":
		body.velocity.y -= 200
		death()
