class_name Card_in_hand extends Control

@onready var card_name_label = $card_name
@onready var card_background = $CardBackground

var card_name: String = ""
var card_is_in_hand_preview := true

signal remove_this_card_from_hand(card: Card_in_hand)

func set_card(name: String) -> void:
	card_name = name
	card_name_label.set_text(card_name)


func _on_button_pressed() -> void:
	emit_signal("remove_this_card_from_hand", self)


func _on_button_mouse_entered() -> void:
	if card_is_in_hand_preview:
		highlight()

func _on_button_mouse_exited() -> void:
	unhighlight()
	
func highlight() -> void:
	card_background.modulate = Color(1, 0.2, 0.2, 0.9)
	
func unhighlight() -> void:
	card_background.modulate = Color(1, 1, 1, 1)
