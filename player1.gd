extends CharacterBody2D

@onready var hitbox_shape = $Hitbox/CollisionShape2D
@onready var hitbox = $Hitbox

@export var up_key := "ui_up"
@export var down_key := "ui_down"
@export var left_key := "ui_left"
@export var right_key := "ui_right"
@export var attack_key := "attack"

var speed = 200
var gravity = 900
var jump_force = -400

func _ready():
	hitbox.connect("area_entered", _on_hitbox_entered)
	hitbox_shape.disabled = true

func _physics_process(delta):
	velocity.y += gravity * delta

	velocity.x = 0
	if Input.is_action_pressed(left_key):
		velocity.x = -speed
	elif Input.is_action_pressed(right_key):
		velocity.x = speed

	if is_on_floor() and Input.is_action_just_pressed(up_key):
		velocity.y = jump_force

	move_and_slide()

	# ATTACCO
	if Input.is_action_just_pressed(attack_key):
		attack()

func attack():
	print("attacco")
	hitbox_shape.disabled = false
	await get_tree().create_timer(0.2).timeout
	hitbox_shape.disabled = true

func _on_hitbox_entered(area):
	print("danno 1")
