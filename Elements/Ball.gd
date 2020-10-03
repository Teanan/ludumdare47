extends RigidBody2D

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _free():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = linear_velocity

func _on_Ball_body_entered(body):
	if (linear_velocity - velocity).length() > 150:
		var bar_notes = ChefOrchestre.notes[ChefOrchestre.bar - 1]
		var note = bar_notes[rand_range(0,bar_notes.size())]
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.pitch_scale = ChefOrchestre.pitch[note]
