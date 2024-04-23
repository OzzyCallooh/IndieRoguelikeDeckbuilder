extends Resource
class_name Currency

@export var name: String = "Currency"
@export var symbol: String = "#"
@export var reset_on_turn_end: bool = true
@export var given_at_start_of_turn: int = 0

func _to_string():
	return "Currency<" + name + ">"
