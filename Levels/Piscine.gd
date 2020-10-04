extends Node

signal did_genit

var poissonsTotal: int = 10
var poissonsInPool: int = poissonsTotal

var baseGenitionTimerValue: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$GenitionTimer.wait_time = baseGenitionTimerValue
	$GenitionTimer.start()

func set_timer(timer: int):
	$GenitionTimer.wait_time = timer

func _geniter():
	var geniteurs = get_tree().get_nodes_in_group("geniteurs")
	for geniteur in geniteurs:
		if geniteur.isActive and (poissonsInPool > 0) :
			geniteur._geniter()
			poissonsInPool -= 1
			emit_signal("did_genit")
