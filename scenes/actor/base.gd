extends CharacterBody2D


@onready var _collision := $CollisionShape2D as CollisionShape2D
@onready var _animation := $AnimatedSprite2D as AnimatedSprite2D

@export var _velocity_max := Vector2(32, 32)
var _direction := Vector2()
