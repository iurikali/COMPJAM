extends Node2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	pass
	
	
func _process(delta: float) -> void:
	if Global.tempo == 45 and Global.estagio == 1:
		Global.estagio = 2
	elif Global.tempo == 30 and Global.estagio == 2:
		Global.estagio = 3
	elif Global.tempo == 15 and Global.estagio == 3:
		Global.estagio = 4
	
	print("Tempo: " + str(Global.tempo))	
	print(Global.estagio)
	pass

func _on_timer_timeout() -> void:
	if Global.tempo: 
		Global.tempo -= 1
	pass # Replace with function body.
