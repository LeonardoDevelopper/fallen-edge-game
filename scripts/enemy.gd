extends CharacterBody2D

const SPEED = 0.1
const JUMP_VELOCITY = -400.0
const IDLE = 0
const WALK = 1
const TURN = 2
var enemy_movement = IDLE
var direction = 1
var hiting = false
var insideHurtBox = false
var player = null
var attacking = false
var attackDamage = 20
var dead = false
@onready var hp = $HP as ProgressBar



func enemy_thinking() -> int:
	return randi_range(0, 2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if $raycast.is_colliding():
		direction *= -1
		$raycast.scale.x = direction
		if direction < 0 :
			$hurtBox.get_children()[0].move_local_x(10, false)
			$hitBox/colisor.move_local_x(-40, false)
			$Collisior.move_local_x(10, false)
		else:
			$Collisior.move_local_x(-10, false)
			$hitBox/colisor.move_local_x(40, false)
			$hurtBox.get_children()[0].move_local_x(-10, false)
			
	if velocity.x != 0 and not attacking and not hiting and not dead:
		$anim.play("walk")
	elif velocity.x == 0 and not attacking and not dead:
		$anim.play("idle")
	
	if not attacking and not hiting and not dead:
		velocity.x = velocity.x + (SPEED * direction)
	
	if dead:
		$Collisior.disabled = true
		$anim.play("dead")
		return
	elif hiting:
		$anim.play("hit")
		return
	elif attacking:
		$anim.play("attack")
		$delay.start(3)
		#return
	if direction < 0 : 
		$anim.flip_h = true
	else:
		$anim.flip_h = false
	if player and player.get_children()[0].animation == "attack":
		hiting = true
	move_and_slide()

func _on_delay_timeout() -> void:
		attacking = true
		#if player:
			#player.get_children()[0].play("hit")


func _on_anim_animation_finished() -> void:
	if $anim.animation == "hit":
		hiting = false 
		$anim.play("idle")
	elif $anim.animation == "attack":
		if player:
			player.get_children()[5].value -= attackDamage
		$anim.play("idle")
		attacking = false
	elif $anim.animation == "dead":
		queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	insideHurtBox = true
	player = area.get_parent();
	if area.get_parent().get_children()[0].animation == 'attack':
		hiting = true

func _on_hurt_box_area_exited(area: Area2D) -> void:
		insideHurtBox = false
		player = null

func _on_hit_box_area_entered(area: Area2D) -> void:
	player = area.get_parent()
	attacking = true

func _on_hit_box_area_exited(area: Area2D) -> void:
	attacking = false
	player = null

func _on_hp_value_changed(value: float) -> void:
	if value < 1:
		dead = true
