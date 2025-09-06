extends Node2D

var SPEED = 200
var saiu = false
var tol_block= 100
var tol_mouse = 10

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shadow_scene := preload("res://Cenas/Cronos/spear_shadow.tscn")

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

	
	var dists = [
		dist(mouse_pos, Vector2(mouse_pos.x,minY)), 
		dist(mouse_pos, Vector2(maxX, mouse_pos.y)),
		dist(mouse_pos, Vector2(mouse_pos.x, maxY)),
		dist(mouse_pos, Vector2(minY, mouse_pos.y))
	]

			

	var valido = verifica_boundary(position, tol_block)
	var mouse_valido = verifica_boundary(mouse_pos, tol_mouse)
	var maximo = dists[0]
	
	var indice = 0
	if mouse_valido:
		for i in range(4):
			if dists[i] < dists[indice]:
				indice = i
	else:
		if mouse_pos.x < minX - tol_mouse:
			indice = 3
		elif mouse_pos.x > maxX + tol_mouse:
			indice = 1
		elif mouse_pos.y < minY - tol_mouse:
			indice = 0
		else:
			indice = 2
	
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
			animated_sprite_2d.rotation_degrees = 180
			position = Vector2(x, minY)
		elif indice == 1:
			animated_sprite_2d.rotation_degrees = -90
			position = Vector2(maxX, y)
		elif indice == 2:
			animated_sprite_2d.rotation_degrees = 0
			position = Vector2(x, maxY)
		else:
			animated_sprite_2d.rotation_degrees = 90
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
	
	if not verifica_boundary(position, tol_block):
		saiu = false
	
	shadow()


func verifica_boundary(pos: Vector2, tolerancia: int):
	return pos.x >= - tolerancia - Global.window_size.x / 2 and pos.x <=  tolerancia + Global.window_size.x / 2  and pos.y >= -tolerancia - Global.window_size.y / 2 and pos.y <= tolerancia + Global.window_size.y / 2 
	
func shadow():
	var shadow_inst := shadow_scene.instantiate()
	shadow_inst.get_node("AnimatedSprite2D").animation = animated_sprite_2d.animation
	shadow_inst.get_node("AnimatedSprite2D").rotation_degrees = animated_sprite_2d.rotation_degrees
	shadow_inst.position = position
	get_tree().current_scene.add_child(shadow_inst, true)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player_runner":
		body.dano()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player_runner":
		body.dano()
