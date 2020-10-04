extends RigidBody2D

var velocity: Vector2
#var velocityThreshold: int = 10
var rng = RandomNumberGenerator.new()

signal poissonDied

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _free():
	if (randi()%2):
		$AudioAeiou1.play()
		yield($AudioAeiou1, "finished")
	else:
		$AudioAeiou2.play()
		yield($AudioAeiou2, "finished")
	emit_signal("poissonDied")
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = linear_velocity

func _on_Ball_body_entered(body):
	if (linear_velocity - velocity).length() > 150:
		var bar_notes = ChefOrchestre.notes[ChefOrchestre.bar]
		var note = bar_notes[rng.randi_range(0,bar_notes.size()-1)]
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.pitch_scale = ChefOrchestre.pitch[note]


func _was_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT and event.is_pressed():
		#print(velocity.length())
		#if (velocity.length() < velocityThreshold):
		self.queue_free()

