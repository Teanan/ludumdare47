extends StaticBody2D

signal ballEntered

func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body.is_in_group("balls"):
		emit_signal("ballEntered", body)
		body.queue_free()