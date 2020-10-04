extends Node2D

signal niveauSup

export (String, FILE, "*.tscn") var Next_Scene: String

const ROTATE_STEP = PI / 8.0;

var elements = {}
var cursorElement: Node2D = null
var cursorElementName: String
var justCreated = false
var money: int
var poissonsReussis: int
var seuils = [3, 6, 9, 12]

var moneyPerPoisson: int = 10

var cost = {
	"Platform": 20,
	"Trampoline": 50,
	"conveyor": 75,
	"Blower": 150
}

func _ready()->void:
	
	preload_elmts()
	
	# Initialize resource values
	set_money(999)
	update_poissons_hud()
	poissonsReussis = 0
	
	# Initialize HUD
	Hud.visible = true
	Hud.connect("buy_item", self, "_on_buy_item")
	PauseMenu.can_show = true
	
	# Start first Genitor
	$Geniteur_1.toggleGeniteur()

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
				cursorElement.rotate(ROTATE_STEP)
			if event.button_index == BUTTON_WHEEL_DOWN:
				cursorElement.rotate(-ROTATE_STEP)

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

		var prefab = elements[name]

		cursorElement = prefab.instance()
		cursorElement.position = get_local_mouse_position()
		cursorElement.modulate = Color(1, 1, 1, 0.5)
		cursorElement.disable_collision(true)
		cursorElementName = name
		justCreated = true

		if name == "Blower":
			cursorElement.rotate(PI)

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
	Hud.set_poissons($Piscine.poissonsInPool, $Piscine.poissonsTotal)
	
# used by bucket
func poisson_reached_bucket():
	$Piscine.poissonsInPool += 1
	$Piscine.poissonsTotal += 1
	update_poissons_hud()
	
	set_money(money + moneyPerPoisson)
	
	poissonsReussis += 1
	if poissonsReussis in seuils:
		emit_signal("niveauSup")

func add_poisson_max():
	$Piscine.poissonsInPool += 1
	$Piscine.poissonsTotal += 1
	update_poissons_hud()

func remove_poisson_died():
	$Piscine.poissonsTotal -= 1
	update_poissons_hud()
	if not $Piscine.poissonsTotal:
		get_tree().change_scene("res://Levels/défaite.tscn")
		ChefOrchestre.stop()

func refund_object(body):
	var c = cost[body.objectType]
	set_money(money + (c/2))
