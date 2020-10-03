extends Node2D

export (String, FILE, "*.tscn") var Next_Scene: String

var elements = {}
var cursorElement: Node2D = null
var justCreated = false

func _ready()->void:
	Hud.visible = true
	PauseMenu.can_show = true
	
	preload_elmts()
	
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
		else:
			cursorElement.modulate = Color(1, 1, 1, 1)
			cursorElement.get_node("CollisionShape2D").disabled = false
			cursorElement = null;
	if Input.is_action_just_released("cancel"):
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
			cursorElement.position = event.position

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
		cursorElement.get_node("CollisionShape2D").disabled = true
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
