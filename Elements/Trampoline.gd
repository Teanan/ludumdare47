extends RigidBody2D

var canBeDestroyed: bool = false
var objectType: String = "Trampoline"

signal wasDestroyed(body)

func _ready():
	pass

func disable_collision(disabled: bool):
	$CollisionShape2D.disabled = disabled

func was_clicked(viewport, event, shape_idx):
	if canBeDestroyed and event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT and event.is_pressed():
		self.queue_free()
		emit_signal("wasDestroyed", self)
