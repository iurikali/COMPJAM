extends Node2D

var SPEED = 200
var saiu = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.window_size = get_viewport().size
	var mouse_pos = get_global_mouse_position()
	position.y = Global.window_size.y
	position.x = mouse_pos.x
	pass # Replace with function body.
		


func dist(pos: Vector2, wall: Vector2):
	return sqrt(pow(pos.x - wall.x, 2) + pow(pos.y - wall.y, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	var dists = [
		dist(mouse_pos, Vector2(mouse_pos.x,0)), 
		dist(mouse_pos, Vector2(Global.window_size.x, mouse_pos.y)),
		dist(mouse_pos, Vector2(mouse_pos.x, Global.window_size.y)),
		dist(mouse_pos, Vector2(0, mouse_pos.y))
	]

	var maximo = dists[0]
	
	var indice = 0
	for i in range(4):
		if dists[i] < dists[indice]:
			indice = i
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		saiu = true
		Global.parede = indice
	
	if not saiu:
		if indice == 0:
			position = Vector2(mouse_pos.x, 0)
		elif indice == 1:
			position = Vector2(Global.window_size.x, mouse_pos.y)
		elif indice == 2:
			position = Vector2(mouse_pos.x, Global.window_size.y)
		else:
			position = Vector2(0, mouse_pos.y)
	else:
		if Global.parede == 0:
			position.y  += delta * SPEED
		elif Global.parede == 1:
			position.x -= delta * SPEED
		elif Global.parede == 2:
			position.y -= delta * SPEED
		else:
			position.x += delta * SPEED
	
	if not verifica_boundary(position):
		saiu = false


func verifica_boundary(pos: Vector2):
	return pos.x >= -30 and pos.x <= Global.window_size.x + 30 and pos.y >= -30 and pos.y <= Global.window_size.y + 30
