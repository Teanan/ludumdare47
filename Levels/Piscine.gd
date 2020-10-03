extends Node

signal did_genit

var poissons: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	print("je suis là")
	$GenitionTimer.start()

func _geniter():
	var geniteurs = get_tree().get_nodes_in_group("geniteurs")
	for geniteur in geniteurs:
		if geniteur.isActive and (poissons > 0) :
			geniteur._geniter()
			poissons -= 1
			emit_signal("did_genit")
