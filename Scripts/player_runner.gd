extends CharacterBody2D

var velh := 0
var velv := 0
var speed := 100

@export var background : Node2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D


var background_width : int 
var background_height : int 

var collsion_width : int
var collision_height : int

func _ready() -> void:
	background_width = background.get_node("Sprite2D").texture.get_width()
	background_height = background.get_node("Sprite2D").texture.get_height()
	collsion_width = collision.shape.size.x
	collision_height = collision.shape.size.y


func _physics_process(delta: float) -> void:
	
	velh = Input.get_axis("LEFT", "RIGHT")
	velv = Input.get_axis("UP", "DOWN")

	velocity.x = velh * speed
	velocity.y = velv * speed
	
	
	print(background.get_node("Sprite2D").texture.get_width())
	move_and_slide()
	position.x = clamp(position.x, -background_width * .5 + collsion_width * .5, background_width * .5 - collsion_width * .5)
	position.y = clamp(position.y, -background_height * .5 + collision_height * .5, background_height * .5 - collision_height * .5)
	
