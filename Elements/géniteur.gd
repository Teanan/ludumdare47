extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# À DÉCOMMENTER SI BESOIN DE TESTER : UNE BALLE PAR SECONDE !
	#var timer = Timer.new()
	#timer.connect("timeout",self,"_geniter")
	#add_child(timer) #to process
	#timer.start()
	pass # Replace with function body.

func _geniter():
	var balle = load("res://Elements/Ball.tscn")
	var noeud = balle.instance()
	add_child(noeud)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
