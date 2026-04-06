extends HBoxContainer

const FLASH_OFFSET := Vector2(8.0, 24.0)

func _print_insufficient() -> void:
	Utils.pdebug("[color=red]Insufficient currency for transaction.[/color]", "CurrencyDisplay")

func _ready() -> void:
	Utils.debug_sent.connect(func(string: String) -> void:
		if "/addkinetic=" in string:
			var _amount: int = string.split("=")[1].to_int()
			var _u := Dwelt.update_currency("kinetic", _amount)
			if !_u: _print_insufficient()
			else: Dwelt.play_flash.emit(%KineticIcon.global_position + FLASH_OFFSET)
		elif "/addelemental=" in string:
			var _amount: int = string.split("=")[1].to_int()
			var _u := Dwelt.update_currency("elemental", _amount)
			if !_u: _print_insufficient()
			else: Dwelt.play_flash.emit(%ElementalIcon.global_position + FLASH_OFFSET)
		elif "/addverdant=" in string:
			var _amount: int = string.split("=")[1].to_int()
			var _u := Dwelt.update_currency("verdant", _amount)
			if !_u: _print_insufficient()
			else: Dwelt.play_flash.emit(%VerdantIcon.global_position + FLASH_OFFSET)
		elif "/addarcane=" in string:
			var _amount: int = string.split("=")[1].to_int()
			var _u := Dwelt.update_currency("arcane", _amount)
			if !_u: _print_insufficient()
			else: Dwelt.play_flash.emit(%ArcaneIcon.global_position + FLASH_OFFSET))
	
	Dwelt.currency_updated.connect(func(currency_id: String) -> void:
		if !currency_id in Save.save.currencies: return
		match currency_id:
			"kinetic": %Kinetic.text = str(Save.save.currencies.kinetic)
			"elemental": %Elemental.text = str(Save.save.currencies.elemental)
			"verdant": %Verdant.text = str(Save.save.currencies.verdant)
			"arcane": %Arcane.text = str(Save.save.currencies.arcane)
			_: pass
	)
