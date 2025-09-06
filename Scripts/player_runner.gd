extends CharacterBody2D

var velh := 0
var velv := 0
var speed := 100

func _physics_process(delta: float) -> void:
	
	velh = Input.get_axis("LEFT", "RIGHT")
	velv = Input.get_axis("UP", "DOWN")

	velocity.x = velh * speed
	velocity.y = velv * speed

		
	move_and_slide()
