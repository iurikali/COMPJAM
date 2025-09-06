extends Node2D

var vel = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.estagio == 2:
		vel = 160
	elif Global.estagio == 3:
		vel = 220
	elif Global.estagio == 4:
		vel = 300
	position.x -= vel * delta
	if position.x < - 768:
		position.x = position.x + 2 * 768
	pass
	
	#1.75 * 640
	#640 * 1.25
