class_name Deck extends Node2D

@onready var card_container = $Card_container/VBoxContainer
@onready var card_textbox = $card_textbox
@onready var cards_in_deck_label = $cards_in_deck_label

@onready var add_card_button = $Button

var CardScene = preload("res://scenes/card.tscn")

var shift_pressed := false

signal add_this_card_to_hand(card: Card)
signal remove_this_card_from_hand(card: Card)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			shift_pressed = event.pressed

func _on_card_textbox_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == "":
		return

	add_card(new_text)

	if not shift_pressed:
		card_textbox.text = ""

func add_card(name: String) -> void:
	var card = CardScene.instantiate()
	card.connect("remove_this_card_from_deck", Callable(self, "_on_remove_this_card_from_deck"))
	card.connect("add_this_card_to_hand", Callable(self, "_on_add_this_card_to_hand"))
	card.connect("remove_this_card_from_hand", Callable(self, "_on_remove_this_card_from_hand"))
	card_container.add_child(card)
	card.set_card(name.strip_edges())
	Variables.deck.append(card.card_name)
	cards_in_deck_label.set_text("cards in deck: " + str(Variables.deck.size()))

func _on_add_this_card_to_hand(card: Card) -> void:
	emit_signal("add_this_card_to_hand", card)
	
func _on_remove_this_card_from_hand(card: Card) -> void:
	emit_signal("remove_this_card_from_hand", card)
	
func _on_remove_this_card_from_deck(card: Card) -> void:
	if card.card_chosen:
		emit_signal("remove_this_card_from_hand", card)
	Variables.deck.erase(card.card_name)
	card_container.remove_child(card)
	card.queue_free()
	cards_in_deck_label.set_text("cards in deck: " + str(Variables.deck.size()))
	
func _on_button_pressed() -> void:
	_on_card_textbox_text_submitted(card_textbox.text)

func unhilight_this_card(card_name: String) -> void:
	for card in card_container.get_children():
		if card.card_name == card_name and card.card_chosen:
			card.card_chosen = false
			card.unhighlight()
			return

func unhighlight_all_cards_from_deck() -> void:
	for card in card_container.get_children():
		if card.card_chosen:
			card.card_chosen = false
			card.unhighlight()
	

func  clear_deck() -> void:
	for card in card_container.get_children():
		_on_remove_this_card_from_deck(card)


func _on_button_mouse_entered() -> void:
	add_card_button.scale.x = 0.065
	add_card_button.scale.y = 0.065
	add_card_button.position.x -= 2
	add_card_button.position.y -= 2

func _on_button_mouse_exited() -> void:
	add_card_button.scale.x = 0.06
	add_card_button.scale.y = 0.06
	add_card_button.position.x += 2
	add_card_button.position.y += 2
