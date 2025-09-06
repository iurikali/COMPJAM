extends Node2D

@export var runner_sprite : AnimatedSprite2D
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	#animated.animation = runner_sprite.animation
	#animated.set_instance_shader_parameter("")
	pass

func _on_timer_timeout() -> void:
	queue_free()
