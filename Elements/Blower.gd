extends Node2D

func _ready():
	pass

func disable_collision(disabled: bool):
	$faucet/CollisionPolygon2D.disabled = disabled
	$water_spray/CollisionPolygon2D.disabled = disabled
	$water_flow/CollisionShape2D.disabled = disabled
