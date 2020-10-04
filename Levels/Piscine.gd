extends Node

signal did_genit

var poissonsTotal: int = 10
var poissonsInPool: int = poissonsTotal

var baseGenitionTimerValue: float = 3
var baseRefillTimerValue: float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$GenitionTimer.wait_time = baseGenitionTimerValue
	$GenitionTimer.start()
	$RefillTimer.wait_time = baseRefillTimerValue
#	$RefillTimer.start()

func set_timer(timer: float):
	print("New timer " + str(timer))
	$GenitionTimer.wait_time = timer
	
func get_timer():
	return $GenitionTimer.wait_time

func _geniter():
	var geniteurs = get_tree().get_nodes_in_group("geniteurs")
	for geniteur in geniteurs:
		if geniteur.isActive and (poissonsInPool > 0) :
			geniteur._geniter()
			poissonsInPool -= 1
			emit_signal("did_genit")

func _attempt_refill():
	if (poissonsTotal < 10):
		poissonsTotal += 1
		poissonsInPool += 1
