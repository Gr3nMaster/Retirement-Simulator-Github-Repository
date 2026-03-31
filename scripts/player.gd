extends CharacterBody2D

signal start_pls

const SPEED = 205.0
const JUMP_VELOCITY = -1010

var is_attacking = false
var last_direction : float = 1.0
var direction : float
var play : bool = false
var HP = 4
var idk_man_this_variable_checks_if_you_were_attacked_or_not_so_you_dont_body_slam_when_hit_by_enemy_knockback : int = 0

@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var animation: AnimatedSprite2D = $WeevilRenderTest
@onready var invincibility: Timer = $invincibility
@onready var buffer: Timer = $buffer
@onready var coyote_time: Timer = $"coyote time"
@onready var particle: CPUParticles2D = $CPUParticles2D

#physics
func _physics_process(delta):
	#if statement to make sure the player only moves when I SAY SO
	if play:
		direction = Input.get_axis("left", "right")
		if direction and not is_attacking:
			velocity.x = direction * SPEED
			last_direction = direction
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 50)
			idk_man_this_variable_checks_if_you_were_attacked_or_not_so_you_dont_body_slam_when_hit_by_enemy_knockback = 0
		
		#uninitiates body slam when touching the ground
		if is_on_floor() and animation.animation == "body slam":
			animation.animation = "idle"
			_on_weevil_render_test_animation_finished()
		
		if not is_attacking:
			if is_on_floor():
				if direction:
					animation.animation = "run"
				else:
					animation.animation = "idle"
			else:
				animation.animation = "jump"
		
	# Handle attacks
		if not is_attacking and is_on_floor():
			if Input.is_action_just_pressed("punch"):
				attack(-48, "punch")
			if Input.is_action_just_pressed("kick"):
				attack(-16, "kick")
		elif not is_attacking and idk_man_this_variable_checks_if_you_were_attacked_or_not_so_you_dont_body_slam_when_hit_by_enemy_knockback == 0:
			if Input.is_action_just_pressed("punch") or Input.is_action_just_pressed("kick"):
				attack(-16, "body slam")
		
		#handle jumping
		if not is_attacking:
			if Input.is_action_just_pressed("jump"):
				if is_on_floor() or not coyote_time.is_stopped():
					velocity.y = JUMP_VELOCITY
				else:
					buffer.start()
			if is_on_floor() and not buffer.is_stopped():
				velocity.y = JUMP_VELOCITY
	else:
		velocity.x = 0
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#sprite flipping
	if last_direction < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false
	
	# yo if you're reading this rn i hope my code is good
	#btw grounded_ig_idk is supposed to be used to initiate coyote time
	var grounded_ig_idk = is_on_floor()
	
	move_and_slide()
	
	if grounded_ig_idk != is_on_floor():
		coyote_time.start()

#attacking
func attack(attack_y, attack_type) -> void:
	match last_direction:
		1.0:
			hitbox.position.x = 32
			particle.position.x = 64
		-1.0:
			hitbox.position.x = -32
			particle.position.x = -64
	hitbox.position.y = attack_y
	is_attacking = true
	hitbox.monitoring = true
	animation.play(attack_type)

func _on_hitbox_body_entered(body: Node2D) -> void:
	#deals damage
	if animation.animation == "body slam":
		body.get_parent().hurt(last_direction, 1.5)
	else:
		body.get_parent().hurt(last_direction, 1)
	
	#play particle effect
	particle.texture.region = Rect2(randi_range(0, 6) * 128, 0, 128, 128)
	particle.get_material().set_shader_parameter("randh", randf_range(0, 1))
	particle.emitting = true

func _on_weevil_render_test_animation_finished() -> void:
	if animation.animation == "begin":
		start_pls.emit()
		animation.play("idle")
	elif animation.animation != "body slam":
		animation.play("idle")
		is_attacking = false
		hitbox.monitoring = false

#damaging
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if invincibility.is_stopped():
		HP -= 1
		if HP == 0:
			_die()
			return
		var cheese : float
		if body.position.x > position.x:
			cheese = -1.0
		else:
			cheese = 1.0
		velocity.y = -400
		velocity.x = cheese * SPEED
		direction = cheese
		
		hurtbox.set_deferred("monitoring", false)
		invincibility.start()
		if is_on_floor():
			idk_man_this_variable_checks_if_you_were_attacked_or_not_so_you_dont_body_slam_when_hit_by_enemy_knockback = 1
		
		move_and_slide()

func _die():
	play = false
	Global.MusicStart = get_parent().fight_music.get_playback_position()
	get_tree().call_deferred("reload_current_scene")

#handle timers
func _on_invincibility_timeout() -> void:
	hurtbox.set_deferred("monitoring", true)
