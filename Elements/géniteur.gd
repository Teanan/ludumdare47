extends Node2D

export var isActive = false

signal myPoissonDied

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("geniteurs")

func _geniter():
#	print("je genite")
	if isActive:
		var balle = load("res://Elements/Ball.tscn")
		var noeud = balle.instance()
		noeud.add_to_group("balls")
		noeud.connect("poissonDied",self,"myPoissonDied")
		add_child(noeud)

func toggleGeniteur():
	isActive = !isActive
	
	if isActive: 
		get_child(1).modulate = '286c0d'
	else:
		get_child(1).modulate = '6c0d0d'

func _on_Geniteur_input_event(viewport, event, shape_idx):
	if !isActive and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		toggleGeniteur()

func myPoissonDied():
	emit_signal("myPoissonDied")
