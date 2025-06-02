class_name Main_screen extends Node2D

@onready var deck = $Deck
@onready var added_hands = $AddedHands
@onready var control_box = $ControlBox
@onready var import_deck_window = $ImportDeck

func _ready() -> void:
	deck.connect("add_this_card_to_hand", Callable(self, "_on_add_this_card_to_hand"))
	deck.connect("remove_this_card_from_hand", Callable(self, "_on_remove_this_card_from_hand"))
	added_hands.connect("this_card_got_removed", Callable(self, "_on_this_card_got_removed"))
	added_hands.connect("unhighlight_all_cards_from_deck", Callable(self, "_on_unhighlight_all_cards_from_deck"))
	import_deck_window.connect("deck_imported", Callable(self, "_on_deck_imported"))

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if import_deck_window.visible:
				import_deck_window.ydk_code_textbox.text = ""
				import_deck_window.hide()


func _on_add_this_card_to_hand(card: Card) -> void:
	added_hands.add_card_to_hand(card.card_name)
	
func _on_remove_this_card_from_hand(card: Card) -> void:
	added_hands.remove_card_from_hand(card.card_name)

func _on_this_card_got_removed(card_name: String) -> void:
	deck.unhilight_this_card(card_name)

func _on_unhighlight_all_cards_from_deck() -> void:
	deck.unhighlight_all_cards_from_deck()


func _on_button_pressed() -> void:
	if import_deck_window.visible:
		import_deck_window.hide()
	else:
		import_deck_window.show()

func _on_deck_imported(decklist: Array) -> void:
	deck.clear_deck()
	import_deck_window.hide()
	for card_name in decklist:
		deck.add_card(str(card_name))


func _on_reset_button_pressed() -> void:
	deck.clear_deck()
	added_hands.clear_added_hands()
	control_box.percentage_label.set_text('0%')
	control_box.good_hands_label.set_text('0')
	control_box.bad_hands_label.set_text('0')
