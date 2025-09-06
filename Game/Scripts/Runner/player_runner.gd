extends CharacterBody2D

var velh := 0
var velv := 0
var speed := 100


var speed_special := 100
var has_special := true
var in_cooldown := false
var special_time := 2
var special_cooldown := 5
@onready var special_time_node: Timer = $"../specialTime"
@onready var special_cooldown_node: Timer = $"../specialCooldown"
@onready var cooldown_sprite: AnimatedSprite2D = $Cooldown
@export var filter : Node2D

@export var background : Node2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var camera : Camera2D
const DEAD_ZOOM_MAX := 4.0
const DEAD_INC := .1
var stop_player := false
var buffer_init := 10

var shadow_scene := preload("res://Cenas/Runner/runner_shadow.tscn")

var state := "idle"

var background_width : int 
var background_height : int 

var collsion_width : int
var collision_height : int

func _ready() -> void:
	background_width = background.get_node("Area2D").get_node("CollisionShape2D").shape.size.x
	background_height = background.get_node("Area2D").get_node("CollisionShape2D").shape.size.y
	Global.window_size = Vector2(background_width, background_height)
	collsion_width = collision.shape.size.x
	collision_height = collision.shape.size.y
	
	special_time_node.wait_time = special_time
	special_cooldown_node.wait_time = special_cooldown

func _process(delta: float) -> void:
	if buffer_init > 0:
		buffer_init -= 1
	state_machine()
	
	if in_cooldown:
		cooldown_sprite.play("default")
	else:
		cooldown_sprite.play("none")



func _physics_process(delta: float) -> void:
	
	if !stop_player:
		velh = Input.get_axis("LEFT", "RIGHT")
		velv = Input.get_axis("UP", "DOWN")

		velocity.x = velh * speed
		velocity.y = velv * speed
	
	move_and_slide()
	position.x = clamp(position.x, -background_width * .5 + collsion_width * .5, background_width * .5 - collsion_width * .5)
	position.y = clamp(position.y, -background_height * .5 + collision_height * .5, background_height * .5 - collision_height * .5)


func state_machine():
	match state:
		"idle":
			sprite.play("idle")
			if velh != 0 or velv != 0:
				sprite.stop()
				state = "running"
		
		"running":
			if velh > 0 && velv == 0:
				if sprite.animation != "right":
					sprite.play("right")
			if velh < 0 && velv == 0:
				if sprite.animation != "left":
					sprite.play("left")
			if velv > 0:
				if sprite.animation != "down":
					sprite.play("down")
			if velv < 0: 
				if sprite.animation != "up":
					sprite.play("up")
			
			#Criando o rastro
			var shadow := shadow_scene.instantiate()
			shadow.position = position
			shadow.get_node("AnimatedSprite2D").animation = sprite.animation
			shadow.get_node("AnimatedSprite2D").frame = sprite.frame
			get_tree().current_scene.add_child(shadow, true)
			
			if velh == 0 && velv == 0:
				sprite.stop()
				state = "idle"
		"dead":
			zoom_camera()
			velh = 0
			velv = 0;
			velocity = Vector2(0, 0)
			stop_player = true
			Global.player_dead = true
			
			anim_morte()
			
			if animation_player.current_animation != "dead":
				animation_player.play("dead")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Special") && has_special):
		special_activate()
	#if (event.is_action_pressed("dead")):
	#	state = "dead"


func dano():
	if buffer_init <= 0:
		state = "dead"
	

func special_activate():
	speed += speed_special
	has_special = false
	filter.get_node("AnimationPlayer").play("on")
	special_time_node.start()

func special_desactivte():
	speed -= speed_special
	in_cooldown = true
	filter.get_node("AnimationPlayer").play("off")
	special_cooldown_node.start()

func _on_special_time_timeout() -> void:
	special_desactivte()


func _on_special_cooldown_timeout() -> void:
	has_special = true
	in_cooldown = false


func zoom_camera():
	camera.zoom = Vector2(lerp(camera.zoom.x, DEAD_ZOOM_MAX, DEAD_INC), lerp(camera.zoom.y, DEAD_ZOOM_MAX, DEAD_INC))
	camera.position = Vector2(lerp(camera.position.x, position.x, DEAD_INC), lerp(camera.position.y, position.y, DEAD_INC))


func reset():
	state = "reset"

func anim_morte():
	if sprite.animation != "dead":
		sprite.play("dead")
	else:
		if sprite.frame >= 6:
			sprite.frame = 6
