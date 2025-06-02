class_name Added_hands extends Node2D

@onready var hand_preview = $ColorRect/ScrollContainer/HBoxContainer
@onready var hand_container = $ScrollContainer/Hand_container
@onready var number_of_good_hands_label = $number_of_good_hands_label
@onready var add_hand_button = $add_hand_button

var CardScene = preload("res://scenes/card_in_hand.tscn")
var HandScene = preload("res://scenes/hand.tscn")

var cards_in_hand: Array = []
var shift_pressed := false
var autodelete := false

signal this_card_got_removed(card_name: String)
signal unhighlight_all_cards_from_deck()

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			shift_pressed = event.pressed

func add_card_to_hand(name: String) -> void:
	cards_in_hand.append(name)
	var preview_card = CardScene.instantiate()
	preview_card.connect("remove_this_card_from_hand", Callable(self, "_on_remove_this_card_from_hand"))
	preview_card.card_name = name
	hand_preview.add_child(preview_card)
	preview_card.set_card(name.strip_edges())

func _on_remove_this_card_from_hand(preview_card: Card_in_hand) -> void:
	cards_in_hand.erase(preview_card.card_name)
	hand_preview.remove_child(preview_card)
	preview_card.queue_free()
	emit_signal("this_card_got_removed", preview_card.card_name)
	
func remove_card_from_hand(name: String) -> void:
	for card in hand_preview.get_children():
		if card.card_name == name:
			cards_in_hand.erase(name)
			hand_preview.remove_child(card)
			card.queue_free()
			break
			
func add_hand():
	var hand = HandScene.instantiate()
	hand.connect("remove_this_hand", _on_remove_this_hand)
	Variables.added_hands.append(hand)
	hand_container.add_child(hand)
	number_of_good_hands_label.set_text("Number of good hands added: " + str(hand_container.get_child_count()))
	for card_name in cards_in_hand:
		hand.add_card(card_name)
	for card in hand.card_container.get_children():
		card.card_is_in_hand_preview = false
		
func _on_remove_this_hand(hand: Hand):
	Variables.added_hands.erase(hand)
	hand_container.remove_child(hand)
	hand.queue_free()
	number_of_good_hands_label.set_text("Number of good hands added: " + str(hand_container.get_child_count()))

func _on_add_hand_button_pressed():
	if cards_in_hand.size() > 0:
		add_hand()
		if autodelete:
			_on_clear_hand_pressed()
			emit_signal("unhighlight_all_cards_from_deck")
	
func _on_clear_hand_pressed():
	cards_in_hand.clear()
	for child in hand_preview.get_children():
		hand_preview.remove_child(child)
		child.queue_free()

func clear_added_hands() -> void:
	cards_in_hand.clear()
	for child in hand_preview.get_children():
		hand_preview.remove_child(child)
		child.queue_free()
	for hand in hand_container.get_children():
		hand_container.remove_child(hand)
		number_of_good_hands_label.set_text("Number of good hands added: 0")
		
func _on_check_button_toggled(toggled_on: bool) -> void:
	if autodelete == true:
		autodelete = false
	else:
		autodelete = true

func _on_add_hand_button_mouse_entered() -> void:
	add_hand_button.scale.x = 0.065
	add_hand_button.scale.y = 0.065
	add_hand_button.position.x -= 2
	add_hand_button.position.y -= 2

func _on_add_hand_button_mouse_exited() -> void:
	add_hand_button.scale.x = 0.06
	add_hand_button.scale.y = 0.06
	add_hand_button.position.x += 2
	add_hand_button.position.y += 2
