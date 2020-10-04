extends Camera2D

var NbDeFoisDezoomee = 0
# FIXME
var ratios = [Vector2(1, 1), Vector2(1.5, 1.5), Vector2(2, 2), Vector2(2.5, 2.5), Vector2(3, 3),  Vector2(3.5, 3.5)]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.zoom = ratios[0]
	pass # Replace with function body.

func dezoom():
	if NbDeFoisDezoomee < 5:
		NbDeFoisDezoomee += 1
	self.zoom = ratios[NbDeFoisDezoomee]
#	self.zoom = self.zoom * 1.5
#	self.zoom = self.zoom * pow((float(1)/ratioBase.x), (float(1)/float(self.get_parent().seuils.size())))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
