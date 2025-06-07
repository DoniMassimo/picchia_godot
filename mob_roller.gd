extends CharacterBody2D

@export var speed := 100.0
@export var jump_velocity := -400.0
@export var gravity := 900.0
@export var jump_distance := 150.0

var player: Node2D
var jump_dir := Vector2.ZERO
var jumping := false
var preparing_jump := false
var angle := 0.0
var rotating := false

@onready var jump_timer := $JumpDelayTimer

func _ready():
	player = $%Player1
	jump_timer.timeout.connect(_on_jump_timer_timeout)

func _physics_process(delta):
	if not player:
		return

	# Gravità
	velocity.y += gravity * delta

	if jumping or rotating:
		proc_rotation(delta)

	# Se a terra e vicino al player, inizia preparazione salto
	if is_on_floor() and not preparing_jump and not jumping:
		if global_position.distance_to(player.global_position) < jump_distance:
			preparing_jump = true
			jump_dir = (player.global_position - global_position).normalized()
			velocity.x = 0 # ferma il mob mentre prende la mira
			jump_timer.start() # avvia il timer per il salto
		else:
			var direction_x = sign(player.global_position.x - global_position.x)
			velocity.x = direction_x * speed
			velocity.y += 300 * delta

	if jumping and is_on_floor():
		jumping = false
		preparing_jump = false
	
	move_and_slide()

func _on_jump_timer_timeout():
	jumping = true
	preparing_jump = false
	jump_to_point(player.global_position, 1)
	jump_timer.stop()

func jump_to_point(target_position: Vector2, flight_time: float):
	var displacement = target_position - global_position
	var velocity_x = displacement.x / flight_time
	var velocity_y = (displacement.y - 0.5 * gravity * pow(flight_time, 2)) / flight_time
	velocity = Vector2(velocity_x, velocity_y)

func proc_rotation(delta: float):
	rotating = true;
	angle += 180 * delta
	angle = fmod(angle, 360)
	var t = absf(sin(deg_to_rad(angle)))
	var scale_x = lerp(1.0, -1.0, t)
	$FrontSpriteWrapper.scale.x = scale_x
	$BackSpriteWrapper.scale.x = scale_x

	if scale_x > 0:
		$FrontSpriteWrapper.visible = true
		$BackSpriteWrapper.visible = false
	else:
		$FrontSpriteWrapper.visible = false
		$BackSpriteWrapper.visible = true

	if is_equal_approx(scale_x, 1.0):
		angle = 0.0
		rotating = false
