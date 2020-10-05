extends StaticBody2D

signal ballEntered(node)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _on_Area_body_entered(body):
	if body.is_in_group("balls"):
		var plouf = rng.randi_range(2, 4)

		if plouf == 2:
			$PloufPlayer2.play()
		if plouf == 3:
			$PloufPlayer3.play()
		if plouf == 4:
			$PloufPlayer4.play()

		emit_signal("ballEntered", self)
		body.queue_free()

func disable_collision(disabled: bool):
	$"CollisionPolygon2D".set_deferred("disabled", disabled)
	$"Area/CollisionShape2D".set_deferred("disabled", disabled)
