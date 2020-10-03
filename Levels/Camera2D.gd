extends Camera2D

var ratioBase = Vector2(0.2, 0.2)
var NbDeFoisDezoomee = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.zoom = ratioBase
	pass # Replace with function body.

func dezoom():
#	self.zoom = self.zoom * 1.5
	self.zoom = self.zoom * pow((float(1)/ratioBase.x), (float(1)/float(self.get_parent().seuils.size())))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
