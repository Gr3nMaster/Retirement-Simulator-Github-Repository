extends CharacterBody2D

signal oh_no_i_died_bleh

const SPEED = 256
const GRAVITY = 2048

@export var direction : float
@onready var animation: AnimatedSprite2D = $Freug
@onready var wall_raycast_l: RayCast2D = $"Wall Raycast L"
@onready var wall_raycast_r: RayCast2D = $"Wall Raycast R"
@onready var invincibility: Timer = $Invincibility
@onready var jump_timer: Timer = $"Jump Timer"
@onready var ouchies: AnimationPlayer = $Freug/AnimationPlayer

var HP : float = 6.0
var play : bool = false:
	set(cheese):
		jump_timer.start()
		play = cheese

func _physics_process(delta: float) -> void:
	if wall_raycast_l.is_colliding():
		direction = 1
	if wall_raycast_r.is_colliding():
		direction = -1
	
	if play == true:
		#GET MOVIN'!
		if is_on_floor():
			velocity.x = 0
			velocity.y = 0
		else:
			velocity.x = direction * SPEED
			velocity.y += GRAVITY * delta
	
	var is_on_floor_methinks : bool = is_on_floor()
	
	move_and_slide()
	
	if is_on_floor_methinks == false and is_on_floor() == true and play == true:
		jump_timer.start()
		animation.play("land")

#cheese is now useless, because der frosch doesn't have knockback.
func hurt(_cheese, damage):
	if invincibility.is_stopped():
		HP -= damage
		if HP == 0 or HP <= 0:
			_die()
			return
		
		invincibility.start()
		ouchies.play("hurt")
		
		move_and_slide()
		

func _die():
	emit_signal("oh_no_i_died_bleh")
	queue_free()

func _on_jump_timer_timeout() -> void:
	animation.play("jump")

func _on_freug_animation_finished() -> void:
	if animation.animation == "jump":
		animation.play("k fly")
		velocity.y = -1024
		move_and_slide()
