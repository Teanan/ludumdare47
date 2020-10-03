extends Node2D

func _ready():
	pass

func disable_collision(disabled: bool):
	$Fan/CollisionShape2D.disabled = disabled
	$Wind/CollisionShape2D.disabled = disabled
