extends CharacterBody2D

@export var speed: float = 100.0

@onready var player = null

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)

func _physics_process(delta):
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
