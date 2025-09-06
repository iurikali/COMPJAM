extends Node2D

var SPEED = 200
var saiu = false
var tolerancia = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
		


func dist(pos: Vector2, wall: Vector2):
	return sqrt(pow(pos.x - wall.x, 2) + pow(pos.y - wall.y, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	var minX = - Global.window_size.x / 2
	var maxX =  Global.window_size.x / 2
	var minY = - Global.window_size.y / 2
	var maxY =  Global.window_size.y / 2
	
	var x
	var y
	
	print(minX)
	print(maxX)
	print(minY)
	print(maxY)
	
	var dists = [
		dist(mouse_pos, Vector2(mouse_pos.x,minY)), 
		dist(mouse_pos, Vector2(maxX, mouse_pos.y)),
		dist(mouse_pos, Vector2(mouse_pos.x, maxY)),
		dist(mouse_pos, Vector2(minY, mouse_pos.y))
	]

			

	var valido = verifica_boundary(position)
	
	var maximo = dists[0]
	
	var indice = 0
	
	for i in range(4):
		if dists[i] < dists[indice]:
			indice = i
	#else:
		#if mouse_pos.x < minX:
			#indice = 3
		#elif mouse_pos.x > maxX:
			#indice = 2
		#elif mouse_pos.y < minY:
			#indice = 0
		#else:
			#indice = 1
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		saiu = true
		Global.parede = indice
	
	if not saiu:
		
		if mouse_pos.x < minX:
			x = minX
		elif mouse_pos.x > maxX:
			x = maxX
		else:
			x = mouse_pos.x
			
		if mouse_pos.y < minY:
			y = minY
		elif mouse_pos.y > maxY:
			y = maxY
		else:
			y = mouse_pos.y
			
		if indice == 0:
			position = Vector2(x, minY)
		elif indice == 1:
			position = Vector2(maxX, y)
		elif indice == 2:
			position = Vector2(x, maxY)
		else:
			position = Vector2(minX, y)
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
	return pos.x >= - tolerancia - Global.window_size.x / 2 and pos.x <=  tolerancia + Global.window_size.x / 2  and pos.y >= -tolerancia - Global.window_size.y / 2 and pos.y <= tolerancia + Global.window_size.y / 2 
	
