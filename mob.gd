extends CharacterBody2D

@export var speed: float = 100.0

@onready var player = null

func _ready():
	player = get_node("%Player1") # Assicurati che "Player1" sia un nodo nella stessa scena

func _physics_process(delta):
	if player == null:
		return

	var direction = Vector2(player.global_position.x - global_position.x, 0).normalized()

	velocity.x = direction.x * speed
	velocity.y += 300 * delta # gravità finta (regola il valore come ti serve)
	move_and_slide()
