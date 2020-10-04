extends Node2D

var canBeDestroyed: bool = false
var objectType: String = "Blower"

signal wasDestroyed(body)

func _ready():
	pass

func disable_collision(disabled: bool):
	$faucet/CollisionPolygon2D.disabled = disabled
	$water_spray/CollisionPolygon2D.disabled = disabled
	$water_flow/CollisionShape2D.disabled = disabled

func was_clicked(viewport, event, shape_idx):
	if canBeDestroyed and event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT and event.is_pressed():
		self.queue_free()
		emit_signal("wasDestroyed", self)
