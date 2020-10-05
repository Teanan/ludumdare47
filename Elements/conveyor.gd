extends RigidBody2D

var canBeDestroyed: bool = false
var objectType: String = "conveyor"

signal wasDestroyed(body)

func _ready():
	pass # Replace with function body.

func disable_collision(disabled: bool):
	$"CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D2/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D3/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D4/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D5/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D6/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D7/CollisionShape2D".set_deferred("disabled", disabled)
	$"Collision zone/Area2D8/CollisionShape2D".set_deferred("disabled", disabled)

func was_clicked(viewport, event, shape_idx):
	if canBeDestroyed and event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT and event.is_pressed():
		self.queue_free()
		emit_signal("wasDestroyed", self)

func _on_ZoneDeClik_mouse_entered():
	if canBeDestroyed and get_parent() != null and get_parent().cursorElement == null:
		modulate = Color(1, 0.1, 0.1, 1)

func _on_ZoneDeClik_mouse_exited():
	modulate = Color(1, 1, 1, 1)
