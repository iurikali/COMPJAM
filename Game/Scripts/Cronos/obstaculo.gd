extends Node2D

var SPEED = 200
var saiu = false
var tol_block= 100
var tol_mouse = 10
var off = 30


@onready var animated_sprite_2d: AnimatedSprite2D = $Area2D/AnimatedSprite2D

var shadow_scene := preload("res://Cenas/Cronos/spear_shadow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position =  Vector2(-Global.window_size.x / 2, -Global.window_size.y / 2)
	pass # Replace with function body.
		


func dist(pos: Vector2, wall: Vector2):
	return sqrt(pow(pos.x - wall.x, 2) + pow(pos.y - wall.y, 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.player_dead:
		var mouse_pos = get_global_mouse_position()
		
		if Global.estagio == 1:
			animated_sprite_2d.play("lv1")
		if Global.estagio == 2:
			animated_sprite_2d.play("lv2")
		elif Global.estagio == 3:
			animated_sprite_2d.play("lv3")
		elif Global.estagio == 4:
			animated_sprite_2d.play("final")
		
		var minX = - Global.window_size.x / 2
		var maxX =  Global.window_size.x / 2
		var minY = - Global.window_size.y / 2
		var maxY =  Global.window_size.y / 2
		
		var x
		var y

		
		#var dists = [
			#dist(mouse_pos, Vector2(mouse_pos.x,minY)), 
			#dist(mouse_pos, Vector2(maxX, mouse_pos.y)),
			#dist(mouse_pos, Vector2(mouse_pos.x, maxY)),
			#dist(mouse_pos, Vector2(minY, mouse_pos.y))
		#]
		
		var dists = [
			abs(minY - mouse_pos.y), 
			abs(maxX - mouse_pos.x),
			abs(maxY - mouse_pos.y),
			abs(minX - mouse_pos.x)
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
				rotation_degrees = 180
				position = Vector2(x, minY - off)
			elif indice == 1:
				rotation_degrees = -90
				position = Vector2(maxX + off, y)
			elif indice == 2:
				rotation_degrees = 0
				position = Vector2(x, maxY + off)
			else:
				rotation_degrees = 90
				position = Vector2(minX - off, y)
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
	else:
		animated_sprite_2d.play("null")
		


func verifica_boundary(pos: Vector2, tolerancia: int):
	return pos.x >= - tolerancia - Global.window_size.x / 2 and pos.x <=  tolerancia + Global.window_size.x / 2  and pos.y >= -tolerancia - Global.window_size.y / 2 and pos.y <= tolerancia + Global.window_size.y / 2 
	
func shadow():
	var shadow_inst := shadow_scene.instantiate()
	shadow_inst.get_node("AnimatedSprite2D").animation = animated_sprite_2d.animation
	shadow_inst.get_node("AnimatedSprite2D").rotation_degrees = rotation_degrees
	shadow_inst.position = position
	get_tree().current_scene.add_child(shadow_inst, true)

func colidiu_com_player(body: Node2D):
	if body.name == "Player_runner":
		body.dano()

func _on_body_entered(body: Node2D) -> void:
	colidiu_com_player(body)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	colidiu_com_player(body)
