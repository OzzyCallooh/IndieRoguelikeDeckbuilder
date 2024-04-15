extends Node2D

var card_scene = load("res://prefabs/card.tscn")
var CARDS = {
	"grass": load("res://resources/card-definitions/grass.tres"),
	"sand": load("res://resources/card-definitions/sand.tres"),
	"rock": load("res://resources/card-definitions/rock.tres")
}
var draw_pile: Array[CardDefn] = [
	CARDS["grass"],
	CARDS["grass"],
	CARDS["grass"],
	CARDS["grass"],
	CARDS["rock"],
	CARDS["rock"],
	CARDS["sand"],
	CARDS["sand"],
	CARDS["sand"],
	CARDS["sand"],
]
var hand: Array[Card] = []
var discard_pile: Array[CardDefn] = []

@onready var draw_pile_node = $DrawPile
@onready var discard_pile_node = $DiscardPile
@onready var hand_container_node = $Hand
@onready var draw_count = $HUD/Control/DrawCount
@onready var discard_count = $HUD/Control/DiscardCount
@onready var energy_count = $HUD/Control/Energy/VBoxContainer/EnergyCount
@onready var in_play_node = $InPlay

var energy = 3:
	set(value):
		energy = value
		if energy_count:
			energy_count.text = str(energy)

func start_turn():
	energy = 3
	draw_hand()

func end_turn():
	discard_hand()
	start_turn()

func draw_hand():
	var tween = create_tween()
	for _i in range(5):
		tween.tween_callback(draw_card)
		tween.tween_interval(0.2)

func discard_hand():
	while hand.size() > 0:
		var i = hand.size() - 1
		discard(hand[i])
		hand.remove_at(i)

func restack_hand():
	var tween = create_tween()
	for i in range(hand.size()):
		var card = hand[i]
		var hand_node = hand_container_node.get_child(i)
		tween.tween_property(card, "transform", hand_node.global_transform, 0.25)
		tween = tween.parallel()

func update_draw_pile():
	draw_pile_node.visible = draw_pile.size() > 0
	draw_count.text = str(draw_pile.size())
	
func update_discard_pile():
	discard_pile_node.visible = discard_pile.size() > 0
	discard_count.text = str(discard_pile.size())

func play_card(card: Card):
	if energy < card.card_defn.cost:
		print("Not enough energy")
		return
	var i = hand.find(card)
	assert(i != -1, "Card is not in hand")
	energy -= card.card_defn.cost
	hand.remove_at(i)
	var tween = create_tween()
	tween.tween_property(card, "transform", in_play_node.global_transform, 0.25)
	tween.tween_interval(0.5)
	tween.tween_callback(func ():
		discard(card)
	)
	$PlaySound.play()
	restack_hand()

func discard(card: Card):
	discard_pile.append(card.card_defn)
	var tween = create_tween()
	tween.tween_property(card, "transform", discard_pile_node.global_transform, 0.25)
	tween.tween_callback(card.queue_free)
	update_discard_pile()
	$DiscardSound.play()

func reshuffle_discard():
	for i in range(discard_pile.size()):
		draw_pile.append(discard_pile[i])
	draw_pile.shuffle()
	discard_pile = []
	update_discard_pile()
	update_draw_pile()
	print("Reshuffled!")
	$ReshuffleSound.play()

func draw_card():
	if draw_pile.size() <= 0 && discard_pile.size() <= 0:
		print("Failed to draw")
		return
	var i = hand.size()
	var hand_node = hand_container_node.get_child(i)
	if hand_node == null:
		return
	if draw_pile.size() <= 0:
		reshuffle_discard()
	var card_defn = draw_pile[0]
	draw_pile.remove_at(0)
	
	var new_card: Card = card_scene.instantiate() as Card
	new_card.card_defn = card_defn
	new_card.transform = draw_pile_node.transform
	var tween = create_tween()
	tween.tween_property(new_card, "transform", hand_node.global_transform, 0.25)
	add_child(new_card)
	hand.append(new_card)
	$DrawSound.play()
	
	new_card.picked.connect(func ():
		if hand.find(new_card) == -1:
			return
		play_card(new_card)
	)
	
	update_draw_pile()

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_pile.shuffle()
	update_discard_pile()
	update_draw_pile()
	start_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_draw_pile_picked():
	draw_card()


func _on_end_turn_pressed():
	end_turn()