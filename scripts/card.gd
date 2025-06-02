class_name Card extends Control

@onready var card_name_label = $Card_name_label
@onready var remove_card_button = $remove_card_button
@onready var card_background = $CardBackground

var card_name: String = ""

var card_chosen := false

signal remove_this_card_from_deck(card: Card)
signal add_this_card_to_hand
signal remove_this_card_from_hand

func set_card(name: String) -> void:
	card_name = name
	card_name_label.set_text(card_name)
	
func _on_remove_card_button_pressed() -> void:
	emit_signal("remove_this_card_from_deck", self)

func _on_choose_this_card_button_pressed() -> void:
	if card_chosen == false:
		card_chosen = true
		highlight()
		emit_signal("add_this_card_to_hand", self)
	else:
		card_chosen = false
		unhighlight()
		emit_signal("remove_this_card_from_hand", self)

func highlight() -> void:
	card_background.modulate = Color(0.3, 1.0, 0.3, 0.7)
	
func unhighlight() -> void:
	card_background.modulate = Color(1, 1, 1, 1)


func _on_choose_this_card_button_mouse_entered() -> void:
	if card_chosen == false:
		card_background.modulate = Color(0.3, 1.0, 0.3, 0.4)
		
func _on_choose_this_card_button_mouse_exited() -> void:
	if card_chosen == false:
		card_background.modulate = Color(1, 1, 1, 1)


func _on_remove_card_button_mouse_entered() -> void:
	remove_card_button.scale.x = 0.06
	remove_card_button.scale.y = 0.06
	remove_card_button.position.x -= 1
	remove_card_button.position.y -= 1

func _on_remove_card_button_mouse_exited() -> void:
	remove_card_button.scale.x = 0.057
	remove_card_button.scale.y = 0.057
	remove_card_button.position.x += 1
	remove_card_button.position.y += 1
