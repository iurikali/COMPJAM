extends Node2D

var vel = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position.x -= vel * delta
	if position.x < - 768:
		position.x = position.x + 2 * 768
	pass
	
	#1.75 * 640
	#640 * 1.25
