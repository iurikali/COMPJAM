extends Node2D

var window_size 
var parede
var tempo = 60
var estagio = 1
var player_dead := false


func _on_ready() -> void:
	pass # Replace with function body.

func call_transition(scene : String):
	Transicao.fade_in(scene)

func call_reset():
	tempo = 60
	estagio = 1
	player_dead = false
	Transicao.fade_in("res://Cenas/main.tscn")
	tempo = 60
	estagio = 1
	player_dead = false
