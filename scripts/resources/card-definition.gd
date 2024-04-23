extends Resource

class_name CardDefn

@export var cost_currencies: Dictionary
@export var gives_currencies: Dictionary
@export var name: String

func _to_string():
	return "CardDefn<" + name + ">"
	
static func currency_dict_as_symbols(currencies: Dictionary):
	var s = ""
	for currency: Currency in currencies.keys():
		var amount: int = currencies[currency]
		if not s.is_empty():
			s += "\n"
		s += currency.symbol.repeat(amount)
	return s

func cost_to_string_as_symbols():
	return currency_dict_as_symbols(cost_currencies)

func gives_to_string_as_symbols():
	return currency_dict_as_symbols(gives_currencies)
