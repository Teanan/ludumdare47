extends Node2D

signal niveauSup

export (String, FILE, "*.tscn") var Next_Scene: String

const ROTATE_STEP = PI / 8.0;

var elements = {}
var cursorElement: Node2D = null
var cursorElementName: String
var justCreated = false
var money: int

var totalGeniteurs: int
var chainePoissons: int = 0
var geniteursActifs: int = 0
var currentNiveau: int = 0
var seuilsPoissons = [5, 10, 20, 20, 20, 9999]
var seuilsGeniteurs = [1, 2, 4, 7, 10, 99]

var moneyPerPoisson: int = 10

var cost = {
	"Platform": 20,
	"Trampoline": 50,
	"conveyor": 75,
	"Blower": 150,
	"Fish": 25,
}

var geniteurCost = [
	0,
	50,
	100,
	200,
	500,
	500,
]

func _ready()->void:

	preload_elmts()

	# Initialize resource values
	set_money(500)
	update_poissons_hud()

	# Initialize zoom
	$Camera.set_zoom_level(currentNiveau)

	# Initialize genitors
	var geniteurs = get_tree().get_nodes_in_group("geniteurs")
	totalGeniteurs = geniteurs.size()
	for geniteur in geniteurs:
		geniteur.connect("iWasClicked", self, "_on_buy_genitor")
		geniteur.connect("myPoissonDied", self, "remove_poisson_died")

	# Initialize HUD
	Hud.visible = true
	Hud.connect("buy_item", self, "_on_buy_item")
	Hud.connect("buy_fish", self, "_on_buy_fish")
	PauseMenu.can_show = true

	# Start first Genitor
	$Geniteur_1.toggleGeniteur()
	geniteursActifs += 1

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
				cursorElement.canBeDestroyed = true
				cursorElement.connect("wasDestroyed", self, "refund_object")
				if cursorElementName == "conveyor":
					cursorElement.get_node("clockwiseArrows").set_visible(false)
					cursorElement.get_node("counterClockwiseArrows").set_visible(false)
				cursorElement = null;
				Hud.set_shop_visible(true)
				popup("-" + str(c), Color(255, 0, 0), get_local_mouse_position())
			else:
				popup("not enought money!", Color(255, 0, 0), get_local_mouse_position())
				print("not enought money")
	if Input.is_action_just_released("cancel"):
		if cursorElement:
			remove_child(cursorElement)
			cursorElement.queue_free()
			cursorElement = null;
			Hud.set_shop_visible(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and cursorElement:
			if event.button_index == BUTTON_WHEEL_UP:
				cursorElement.rotate(ROTATE_STEP)
				if cursorElementName == "conveyor" and fmod(abs(cursorElement.get_rotation()), PI) > PI/2 :
					switch_conveyor()
			if event.button_index == BUTTON_WHEEL_DOWN:
				cursorElement.rotate(-ROTATE_STEP)
				if cursorElementName == "conveyor" and fmod(abs(cursorElement.get_rotation()), PI) > PI/2 :
					switch_conveyor()

	if event is InputEventMouseMotion:
		if cursorElement:
			#cursorElement.position = event.position
			cursorElement.position = get_local_mouse_position()

func switch_conveyor():
	var current = cursorElement.get_rotation()
	if current < 0:
		cursorElement.set_rotation(current + PI)
	else:
		cursorElement.set_rotation(current - PI)
	cursorElement.get_node("clockwiseArrows").set_visible(not cursorElement.get_node("clockwiseArrows").is_visible())
	cursorElement.get_node("counterClockwiseArrows").set_visible(not cursorElement.get_node("counterClockwiseArrows").is_visible())
	print(cursorElement.get_node("clockwiseArrows").is_visible())
	print(cursorElement.get_node("counterClockwiseArrows").is_visible())
	cursorElement.apply_scale(Vector2(-1, 1))

func _on_buy_item(name):
	if not name in elements:
		printerr("cannot find element res://Elements/" + name + ".tscn")
	else:
		if cursorElement:
			remove_child(cursorElement)
			cursorElement.queue_free()

		Hud.set_shop_visible(false)

		var prefab = elements[name]

		cursorElement = prefab.instance()
		cursorElement.position = get_local_mouse_position()
		cursorElement.modulate = Color(1, 1, 1, 0.5)
		cursorElement.disable_collision(true)
		cursorElementName = name
		justCreated = true

		if cursorElementName == "conveyor":
			cursorElement.get_node("clockwiseArrows").set_visible(true)

		if name == "Blower":
			cursorElement.rotate(PI)

		add_child(cursorElement)

func _on_buy_fish(amount: int):
	var c = cost["Fish"]
	if money >= c:
		set_money(money - c)
		add_poisson_max(amount * geniteursActifs)
		popup("-" + str(c), Color(255, 0, 0), get_local_mouse_position())
	else:
		popup("not enought money!", Color(255, 0, 0), get_local_mouse_position())

func _on_buy_genitor(genitor):
	var c = geniteurCost[currentNiveau]
	if money >= c:
		set_money(money - c)
		genitor.toggleGeniteur()
		chainePoissons = 0
		geniteursActifs += 1
		popup("-" + str(c), Color(255, 0, 0), get_local_mouse_position())
	else :
		popup("not enought money!", Color(255, 0, 0), get_local_mouse_position())

func refresh_genitor_prices():
	var geniteurs = get_tree().get_nodes_in_group("geniteurs")
	for geniteur in geniteurs:
		geniteur._update_price(geniteurCost[currentNiveau])

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
	Hud.set_poissons($Piscine.poissonsInPool, $Piscine.poissonsTotal)

# used by bucket
func poisson_reached_bucket(poissonNode):
	$Piscine.poissonsInPool += 1
	update_poissons_hud()

	popup("+" + str(moneyPerPoisson), Color(0, 255, 0), poissonNode.position)
	set_money(money + moneyPerPoisson)

	chainePoissons += 1

	print("Poi: " + str(chainePoissons) + " Gen: " + str(geniteursActifs) + " Niv: " + str(currentNiveau))

	if chainePoissons >= seuilsPoissons[currentNiveau] && geniteursActifs >= seuilsGeniteurs[currentNiveau]:
		chainePoissons = 0
		level_up()
		$Camera.set_zoom_level(currentNiveau)
	
	if currentNiveau == 5 and chainePoissons > 100 and geniteursActifs == totalGeniteurs:
		chainePoissons = 0
		$Piscine.set_timer($Piscine.get_timer() * 0.9)

func level_up():
	currentNiveau += 1
	refresh_genitor_prices()

func add_poisson_max(amount: int):
	$Piscine.poissonsInPool += amount
	$Piscine.poissonsTotal += amount
	update_poissons_hud()

func remove_poisson_died():
	chainePoissons = 0
	$Piscine.poissonsTotal -= 1
	update_poissons_hud()
	if not $Piscine.poissonsTotal and money < cost["Fish"]:
		game_over()

func game_over(): 
	get_tree().change_scene("res://Levels/défaite.tscn")
	ChefOrchestre.stop()

func refund_object(body):
	var c = cost[body.objectType]
	set_money(money + (c/2))
	popup("+" + str(c/2), Color(0, 255, 0), get_local_mouse_position())

func popup(text, color, pos):
	var t = load("res://Elements/Text.tscn").instance()
	add_child(t)
	t.position = pos
	t.set_floating_text(text)
	t.set_floating_color(color)
