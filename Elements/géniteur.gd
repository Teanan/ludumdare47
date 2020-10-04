extends Node2D

export var isActive = false
export var price = "500"

signal myPoissonDied

var tex_open = load('res://Assets/Sprites/geniteur_sprite.png')
var tex_closed = load('res://Assets/Sprites/geniteur_sprite_closed.png')
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("geniteurs")
	get_node("Money_tag/Price").set_text(price)
	setSprite(isActive)

func _geniter():
#	print("je genite")
	if isActive:
		var balle = load("res://Elements/Ball.tscn")
		var noeud = balle.instance()
		noeud.add_to_group("balls")
		noeud.connect("poissonDied", self, "myPoissonDied")
		add_child(noeud)

func toggleGeniteur():
	isActive = !isActive
	setSprite(isActive)

func setSprite(open):
	if open:
		get_node("Sprite").set_texture(tex_open)
		get_node("Money_tag").set_visible(false)
	else:
		get_node("Sprite").set_texture(tex_closed)


func _on_Geniteur_input_event(viewport, event, shape_idx):
	if !isActive and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		toggleGeniteur()

func myPoissonDied():
	emit_signal("myPoissonDied")
