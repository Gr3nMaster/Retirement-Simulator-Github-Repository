extends CharacterBody2D

signal oh_no_i_died_bleh

const SPEED = 175.0

@export var direction : float
@onready var animation: AnimatedSprite2D = $UfoGuyana
@onready var invincibility: Timer = $Invincibility
@onready var wall_raycast_l: RayCast2D = $"Wall Raycast L"
@onready var wall_raycast_r: RayCast2D = $"Wall Raycast R"
@onready var ouchies: AnimationPlayer = $UfoGuyana/AnimationPlayer

var HP : float = 3.0
var play : bool = false

func _physics_process(delta: float) -> void:
	if wall_raycast_l.is_colliding():
		direction = 1
	if wall_raycast_r.is_colliding():
		direction = -1
	
	if play == true:
		if is_on_floor():
			velocity.x = direction * SPEED
		else:
			velocity += get_gravity() * delta
	
	if direction > 0:
		animation.flip_h = true
	else:
		animation.flip_h = false
	
	var is_on_floor_methinks : bool = is_on_floor()
	
	move_and_slide()
	
	if is_on_floor_methinks == false and is_on_floor() == true:
		animation.play("idle")

#same logic for enemy_1
func hurt(cheese, damage):
	if invincibility.is_stopped():
		HP -= damage
		if HP == 0 or HP <= 0:
			_die()
			return
		velocity.y = -500
		velocity.x = cheese * SPEED
		direction = cheese
		
		animation.set_deferred("animation", "hit")
		invincibility.start()
		ouchies.play("hurt")
		
		move_and_slide()

func _die():
	emit_signal("oh_no_i_died_bleh")
	queue_free()
