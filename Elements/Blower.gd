extends Node2D

var canBeDestroyed: bool = false
var objectType: String = "Blower"

signal wasDestroyed(body)

func _ready():
	pass

func disable_collision(disabled: bool):
	$faucet/CollisionPolygon2D.set_deferred("disabled", disabled)
	$water_spray/CollisionPolygon2D.set_deferred("disabled", disabled)
	$water_flow/CollisionShape2D.set_deferred("disabled", disabled)

func was_clicked(viewport, event, shape_idx):
	if canBeDestroyed and event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT and event.is_pressed():
		self.queue_free()
		emit_signal("wasDestroyed", self)

func _on_Area2D_mouse_entered():
	if canBeDestroyed and get_parent() != null and get_parent().cursorElement == null:
		$faucet.modulate = Color(1, 0.25, 0.25, 1)

func _on_Area2D_mouse_exited():
	$faucet.modulate = Color(1, 1, 1, 1)
