extends CharacterBody2D

var velh := 0
var velv := 0
var speed := 100

@export var background : Node2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D

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

func _process(delta: float) -> void:
	state_machine()
	pass


func _physics_process(delta: float) -> void:
	

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


func dano():
	print("D")
