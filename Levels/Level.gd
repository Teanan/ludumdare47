extends Node2D

signal niveauSup

export (String, FILE, "*.tscn") var Next_Scene: String

var elements = {}
var cursorElement: Node2D = null
var cursorElementName: String
var justCreated = false
var money: int
var poissonsReussis: int
var seuils = [3, 6, 9, 12]

var cost = {
	"Platform": 20,
	"Trampoline": 50,
	"Blower": 150
}

func _ready()->void:
	poissonsReussis = 0
	Hud.visible = true
	PauseMenu.can_show = true
	
	preload_elmts()
	
	set_money(999)
	update_poissons_hud()
	
	Hud.connect("buy_item", self, "_on_buy_item")

func _on_Button_pressed()->void:
	Game.emit_signal("ChangeScene", Next_Scene)

func _exit_tree()->void:
	Hud.visible = false
	PauseMenu.can_show = false

func _process(delta):
	if Input.is_action_just_released("click"):
		if justCreated:
			justCreated = false
		elif cursorElement:
			var c = cost[cursorElementName]
			if money >= c:
				set_money(money - c)
				cursorElement.modulate = Color(1, 1, 1, 1)
				cursorElement.disable_collision(false)
				cursorElement = null;
			else:
				print("not enought money")
	if Input.is_action_just_released("cancel"):
		if cursorElement:
			remove_child(cursorElement)
			cursorElement.queue_free()
			cursorElement = null;

func _input(event):	
	if event is InputEventMouseButton:
		if event.is_pressed() and cursorElement:
			if event.button_index == BUTTON_WHEEL_UP:
				cursorElement.rotate(0.2)
			if event.button_index == BUTTON_WHEEL_DOWN:
				cursorElement.rotate(-0.2)

	if event is InputEventMouseMotion:
		if cursorElement:
			#cursorElement.position = event.position
			cursorElement.position = get_local_mouse_position()

func _on_buy_item(name):
	if not name in elements:
		printerr("cannot find element res://Elements/" + name + ".tscn")
	else:
		if cursorElement:
			remove_child(cursorElement)
			cursorElement.queue_free()

		var mouse = get_viewport().get_mouse_position()
		var prefab = elements[name]

		cursorElement = prefab.instance()
		cursorElement.position = mouse
		cursorElement.modulate = Color(1, 1, 1, 0.5)
		cursorElement.disable_collision(true)
		cursorElementName = name
		justCreated = true

		add_child(cursorElement)

func preload_elmts():
	var elements_directory = Directory.new()
	elements_directory.open("res://Elements")
	elements_directory.list_dir_begin(true)

	var element = elements_directory.get_next()
	while element != "":
		if ".tscn" in element:
			elements[element.replace(".tscn", "")] = load("res://Elements/" + element)
		element = elements_directory.get_next()

func set_money(_money):
	money = _money
	Hud.set_money(_money)
	
func update_poissons_hud():
	Hud.set_poissons($Piscine.poissons)
	
func add_poisson():
	print("dans le seau")
	$Piscine.poissons += 1
	update_poissons_hud()

	poissonsReussis = poissonsReussis + 1
	if poissonsReussis in seuils:
		emit_signal("niveauSup")
