extends RigidBody2D

func _ready():
	pass

func disable_collision(disabled: bool):
	$CollisionShape2D.disabled = disabled
