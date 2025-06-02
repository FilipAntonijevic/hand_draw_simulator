class_name Control_box extends Node2D

@onready var hand_size_textbox = $hand_size_textbox
@onready var number_of_games_textbox = $number_of_hands_textbox
@onready var calculate_button = $calculate_button
@onready var good_hands_label = $good_hands_label
@onready var bad_hands_label = $bad_hands_label
@onready var percentage_label = $percentage_label
@onready var increse_hand_size_button = $increse_hand_size
@onready var decrese_hand_size_button = $decrese_hand_size

var good_hands_counter = 0
var bad_hands_counter = 0
	
func _on_calculate_button_pressed() -> void:
	var hand_size = hand_size_textbox.text
	var number_of_games = number_of_games_textbox.text
	calculate(int(number_of_games), int(hand_size))
	
func calculate(number_of_games: int, hand_size: int) -> void:
	good_hands_counter = 0
	bad_hands_counter = 0

	for i in range(0, number_of_games):
		if draw_hand_and_check_subsets(hand_size) == false:
			return
	
	good_hands_label.set_text(str(good_hands_counter))
	bad_hands_label.set_text(str(bad_hands_counter))
	var percentage = float(good_hands_counter) / number_of_games
	percentage = round(percentage * 10000.0) / 100.0
	percentage_label.set_text(str(percentage) + '%')
	
func draw_hand_and_check_subsets(hand_size: int) -> bool:
	if hand_size > Variables.deck.size():
		return false

	var shuffled_deck = Variables.deck.duplicate()
	shuffled_deck.shuffle()
	var new_hand = shuffled_deck.slice(0, hand_size)

	var good_hand_found = false
	for hand in Variables.added_hands:
		if is_hand_good(hand.cards_in_hand, new_hand):
			good_hand_found = true
			break
			
	if good_hand_found:
		good_hands_counter += 1
	else:
		bad_hands_counter += 1
	
	return true

func is_hand_good(hand: Array, new_hand: Array) -> bool:
	var new_hand_counts := {}
	for card in new_hand:
		new_hand_counts[card] = new_hand_counts.get(card, 0) + 1

	for card in hand:
		if not new_hand_counts.has(card) or new_hand_counts[card] <= 0:
			return false
		new_hand_counts[card] -= 1

	return true


func _on_increse_hand_size_pressed() -> void:
	hand_size_textbox.set_text(str(int(hand_size_textbox.text) + 1))


func _on_decrese_hand_size_pressed() -> void:
	if int(hand_size_textbox.text) > 0:
		hand_size_textbox.set_text(str(int(hand_size_textbox.text) - 1))


func _on_increse_hand_size_mouse_entered() -> void:
	increse_hand_size_button.scale.x = 0.065
	increse_hand_size_button.scale.y = 0.065
	increse_hand_size_button.position.x -= 1
	increse_hand_size_button.position.y -= 1

func _on_increse_hand_size_mouse_exited() -> void:
	increse_hand_size_button.scale.x = 0.06
	increse_hand_size_button.scale.y = 0.06
	increse_hand_size_button.position.x += 1
	increse_hand_size_button.position.y += 1

func _on_decrese_hand_size_mouse_entered() -> void:
	decrese_hand_size_button.scale.x = 0.065
	decrese_hand_size_button.scale.y = 0.065
	decrese_hand_size_button.position.x -= 1
	decrese_hand_size_button.position.y -= 1

func _on_decrese_hand_size_mouse_exited() -> void:
	decrese_hand_size_button.scale.x = 0.06
	decrese_hand_size_button.scale.y = 0.06
	decrese_hand_size_button.position.x += 1
	decrese_hand_size_button.position.y += 1
