extends Node2D
class_name Card

signal picked

@onready var front = $Front
@onready var back = $Back
@onready var card_name = $Front/Control/CardName
@onready var card_cost = $Front/Control/Cost
@onready var gives = $Front/Control/Gives
var card_defn: CardDefn:
	set(value):
		card_defn = value
		update()

func update():
	if front:
		front.visible = card_defn != null
	if back:
		back.visible = card_defn == null
	if card_defn != null:
		if card_name != null:
			card_name.text = card_defn.name
		if card_cost != null:
			card_cost.text = card_defn.cost_to_string_as_symbols()
		if gives != null:
			gives.text = card_defn.gives_to_string_as_symbols()
	else:
		pass

func pick():
	picked.emit()

func _ready():
	update()

func _init():
	card_defn = null

func _on_pick_pressed():
	pick() # Replace with function body.
