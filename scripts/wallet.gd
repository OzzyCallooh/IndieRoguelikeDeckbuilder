class_name Wallet

signal currency_changed(currency: Currency, amount: int)

var currencies: Dictionary = {}

func get_currency(currency: Currency):
	return currencies.get(currency, 0)

func set_currency(currency: Currency, amount: int):
	currencies[currency] = amount
	currency_changed.emit(currency, amount)

func has_currency(currency: Currency, amount: int):
	return get_currency(currency) >= amount

func has_currencies(currencies2: Dictionary):
	for currency: Currency in currencies2.keys():
		var amount: int = currencies2[currency]
		if not has_currency(currency, amount):
			return false
	return true

func give_currency(currency: Currency, amount: int):
	set_currency(currency, get_currency(currency) + amount)

func give_currencies(currencies2: Dictionary):
	for currency: Currency in currencies2.keys():
		var amount: int = currencies2[currency]
		give_currency(currency, amount)

func take_currency(currency: Currency, amount: int):
	give_currency(currency, -amount)

func take_currencies(currencies2: Dictionary):
	for currency: Currency in currencies2.keys():
		var amount: int = currencies2[currency]
		take_currency(currency, amount)

func _to_string():
	var s = ""
	for currency: Currency in currencies.keys():
		var amount: int = currencies[currency]
		if not s.is_empty():
			s += "\n"
		s += str(amount) + currency.symbol
	return s

func to_string_as_symbols():
	var s = ""
	for currency: Currency in currencies.keys():
		var amount: int = currencies[currency]
		if not s.is_empty():
			s += "\n"
		s += currency.symbol.repeat(amount)
	return s
