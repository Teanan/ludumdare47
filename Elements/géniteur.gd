extends Node2D

export var isActive = false
export var defaultPrice = "50"

var shinyRate = 100

signal myPoissonDied
signal iWasClicked(me)

var tex_open = load('res://Assets/Sprites/geniteur_sprite.png')
var tex_closed = load('res://Assets/Sprites/geniteur_sprite_closed.png')

func _ready():
	self.add_to_group("geniteurs")
	get_node("Money_tag/Price").set_text(defaultPrice)
	setSprite(isActive)

func _update_price(newPrice: int):
	get_node("Money_tag/Price").set_text(str(newPrice))
	
func _geniter():
	if isActive:
		var balle = load("res://Elements/Ball.tscn")
		var noeud = balle.instance()
		noeud.add_to_group("balls")
		noeud.connect("poissonDied", self, "myPoissonDied")

		if (not randi() % shinyRate):
			noeud.modulate = "#ffd700"

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
		emit_signal("iWasClicked", self)

func myPoissonDied():
	emit_signal("myPoissonDied")
