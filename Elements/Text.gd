extends Node2D

var floating_text: = "" setget set_floating_text
var floating_color: = Color(1,1,1,1) setget set_floating_color

onready var tween : Tween = $OpacityTween
onready var posTween : Tween = $OpacityTween

func _ready():
	tween.interpolate_property($Text, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 4,
		Tween.TRANS_SINE , Tween.EASE_OUT)
	posTween.interpolate_property($Text, "rect_position",
		$Text.rect_position + Vector2(0, 0), $Text.rect_position + Vector2(0.0, -10.0), 5,
		Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	posTween.start()

func set_floating_text(value: String)->void:
	$Text.text = value

func set_floating_color(value: Color)->void:
	$Text.set("custom_colors/font_color",value)

func _on_OpacityTween_tween_completed(object, key):
	queue_free()
