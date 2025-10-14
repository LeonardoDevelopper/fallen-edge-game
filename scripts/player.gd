extends CharacterBody2D

@onready var anim = $anim

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var attacking = false
var hitPoint = 100
var attackDamage = 15
var takingDamage = false
var enemyClose = null
var dead = false
func attack():
	anim.play("attack")
	print("HELLO\n\n")
	await anim.animation_finished
	print("WORLD\n\n")
	anim.play("idle")
	

func _physics_process(delta: float) -> void:
	
	if $HP.value < 1:
		if not dead:
			$anim.play("dead")
			dead = true
		return 
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#		===========Animations==============
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		anim.flip_h = true
		
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		anim.flip_h = false
		

	if Input.is_action_just_pressed("ui_attack_btn") :
		attacking = true
		anim.play("attack")
		if enemyClose:
			enemyClose.get_children()[6].value -= attackDamage
	
	else:
		velocity.x = direction.x * SPEED
	

	#print("Taking damage: ", takingDamage)
	#if enemyClose and enemyClose.get_children()[0].animation != "attack":
		#takingDamage = false
	if is_on_floor():
		if enemyClose and enemyClose.get_children()[0].animation == "attack":
			takingDamage = true
		else:
			takingDamage = false

		if takingDamage:
			anim.play("hit")
			return
		if velocity.x != 0 and not attacking and not takingDamage:
			anim.play("walk")
		elif velocity.x == 0 and not attacking and not takingDamage:
			anim.play("idle")

	elif not is_on_floor() and not attacking:
		anim.play("jump")

	move_and_slide()

func _on_anim_animation_finished() -> void:
	velocity.x = 0
	#takingDamage = false
	attacking = false
	if not dead: 
		anim.play("idle")

func _on_hit_box_area_entered(area: Area2D) -> void:
	enemyClose = area.get_parent()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	#print(area.get_parent().name)
	#if area.get_parent().name == "energy" or area.get_parent().name == "coins":
		#$Energy.value += 15
		#enemyClose = null
	#else:
	enemyClose = area.get_parent()

func _on_hurt_box_area_exited(area: Area2D) -> void:
	enemyClose = null

func _on_timer_timeout() -> void:
	attacking = true
	anim.play("attack")
	if enemyClose:
		enemyClose.get_children()[6].value -= attackDamage
	
